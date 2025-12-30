Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 802D0E95A77
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 11:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4856B008A; Tue, 30 Dec 2025 06:40:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27D36B008C; Tue, 30 Dec 2025 06:40:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31286B0092; Tue, 30 Dec 2025 06:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE1F06B008A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 06:40:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 558321CE1C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:40:30 +0000 (UTC)
X-FDA: 84275944620.22.0019798
Received: from outbound.mr.icloud.com (p-west2-cluster2-host4-snip4-9.eps.apple.com [57.103.68.162])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2367C180006
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:40:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bne-home.net header.s=sig1 header.b=YHn+NP5E;
	spf=pass (imf16.hostedemail.com: domain of bshephar@bne-home.net designates 57.103.68.162 as permitted sender) smtp.mailfrom=bshephar@bne-home.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767094828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rACcEN+epuIthxdvgF0dC9KzjjSyrOZmhlIZhCJHJrw=;
	b=OvUF8rFKdjJrifjqoFyJV0AJOaWPCAeDcO7GDOntNU93sn9Kpr/IZ45NNRsRLTt7uymD5h
	a+3jD0e4xtz/T3uhPAJGOgH8jd5/aMnSZDC/QACNBrjFDzSFC7ccddbqae5N/n4Miw1RzR
	3Bzor5OlStJpH4ShRG/eFPXGHC9/kaw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bne-home.net header.s=sig1 header.b=YHn+NP5E;
	spf=pass (imf16.hostedemail.com: domain of bshephar@bne-home.net designates 57.103.68.162 as permitted sender) smtp.mailfrom=bshephar@bne-home.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767094828; a=rsa-sha256;
	cv=none;
	b=zVFf4pz8SUgGI71lVN8kubs7rcBFRxRcLvujsVRWuQyMqt99n1wZCWrbAmajVd9KLoYtye
	0yXAtD8bg/Qk+1d3FNxnckEy0TMkuSUo7q7sSnkepElR7T5eQOmnAwHmgh23kwLUqEa9Ay
	Cix/EkdX95+5cp4bwCwjdIkgK3b+0mg=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-5 (Postfix) with ESMTPS id 7487D1800113;
	Tue, 30 Dec 2025 11:40:25 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bne-home.net; s=sig1; bh=rACcEN+epuIthxdvgF0dC9KzjjSyrOZmhlIZhCJHJrw=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=YHn+NP5EOqNJNEjV9K8t5iWH5X0sCT3buiKP5yCCKSnUKBWyXZKpZa0y81131XfW/Rpjw2ZfUb9ODnKNA2t4lllX1zgJilf9anOpzsgvWxAcbVeLIv5ll99xbaTK0QKaEMXMGqzRr/ETJQttQRkjHJ1RvoU/S0D8d51YTwwPPXSvqEq6IB5V2d1WRUowkkU0XjA973+bAx8Ae+/ORl5SK9yB9ouNavkp7xgJyOvlCGTY0q4HyvpY/pqYgEmm8yX+u6KnGtCFs3LxWIDTXXUl6TmZfViQbNuiU+myjvrtBRpLm5rdEV7IF3ZkFYKfO4m9crLGYflRcGYUBxu7oEYzXg==
mail-alias-created-date: 1746336505199
Received: from fedora-g16.bne-home.net (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-5 (Postfix) with ESMTPSA id 647B51800605;
	Tue, 30 Dec 2025 11:40:21 +0000 (UTC)
Date: Tue, 30 Dec 2025 21:40:17 +1000
From: Brendan Shephard <bshephar@bne-home.net>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: aliceryhl@google.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, ojeda@kernel.org, boqun.feng@gmail.com,
	gary@garyguo.net, bjorn3_gh@protonmail.com, lossin@kernel.org,
	a.hindborg@kernel.org, tmgross@umich.edu, dakr@kernel.org,
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: Test page_align usize::MAX boundary edges
Message-ID: <aVO6ISXoEV-43AY2@fedora-g16.bne-home.net>
References: <20251230094841.76830-1-bshephar@bne-home.net>
 <aVOhfWmyJBxD4SUa@fedora-g16.bne-home.net>
 <CANiq72mdkb6A82oy0DoUWn=jv75-R7EHTNvJRW7o=JeNa3eeHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mdkb6A82oy0DoUWn=jv75-R7EHTNvJRW7o=JeNa3eeHg@mail.gmail.com>
X-Authority-Info: v=2.4 cv=SJRPlevH c=1 sm=1 tr=0 ts=6953ba2a cx=c_apl:c_pps
 a=9OgfyREA4BUYbbCgc0Y0oA==:117 a=9OgfyREA4BUYbbCgc0Y0oA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=JppZAXPjAAAA:8 a=KjuJQINMKESoCGrhKMMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=mTXuAFqUwmiQvsSFmwXH:22
X-Proofpoint-ORIG-GUID: vho5jMJbJ3Iu9FhNZOQDabgr1nQBFRdF
X-Proofpoint-GUID: vho5jMJbJ3Iu9FhNZOQDabgr1nQBFRdF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDEwNSBTYWx0ZWRfXz/cVO6yBSkgP
 FMthBgfTlo3eypm0FD2K6BkCaaSipphS4lPhZiFwqnQ7iJ8vUPRXEB4/e/I1mYez17uAas6Snex
 yg3qXN534a9n/PRmdZHbYQunNvgGnLpiKXNKU1J2J2mVJ/zbzAMuBJhqlr/DVmoOfyXHrhpBXuo
 /lcstEfla6rji+80Idiydam7aVI0GqR5IcrbRgDv/JMnZJ8FD6exGPpJqvxLDbzVxLmL67ZJdKQ
 3SVzPcaeFGcCdfGfQqeAi86rMH+Y8Rn04eyuvqJjGuXeXZJXpZRRNvOKRjb9V9rj8R/H4kiqh+D
 WJ3pJ8LM1NtOUI9fEbX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 spamscore=0 clxscore=1030 suspectscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512300105
X-JNJ: AAAAAAABFWRGzDXrD9N47VQlOiCFXOKL0P79vIoQewS0CJ65F+Rmbp61IVkboV6sGgBUyqjOhE/hsH1Z/wxHqkq9giM+vRpIa7evVxpz+Qd3jCcHAqqT6/SLMRHNLq66VVDQ7HkC7CrBLO8qMMLOKCUp4zHTDfjGIHBJNNzO+kYbGmAeI+x5Rlk3Tw5fLvM7O9uEHoY8RnF7URR2mtw/3522vxdvDiGt8bQLfNEN96+O3xnTW1a4DMwIb22VhGOZtxat20opb7I8ITAH/GUme/UM9/k8/emXZtxcnhlXcxKcEvFAte/YN0vm1lYF+mL+wCceLB7LleMK1Q7SDboWJPMo63bI4+aFyowKTk3DVW1WVV1Ow9Z2Naxq5jDxAFfsY0u8HeW/GOjjtD3FThNc3ntjvWTg/mG9vVUCog9PBvsPLM0AxciRTKOjXApzyGK096yEQEuiQu7Q4UuetxS1xYfCPuCBitcvPDPbSx/nE6QdKtpM0WQYaaIxD8neGjYYflZF0e9xAo2+yoC1jrAr1wV+gK99b5PcUVWR6+Faoca0CTacgbosndliXSG9sGM5cIAtTb73fcbYZE1Mc9YvO0rsJYqEmQYWX2VEpbPJUO7hZelkc4rve0NJ6DCC8oYS79ZvQuSKLBTWGWK2ilP+nguQK68Kg28Yb19eaKf/oVCCggBTaVxCX8/9DKpkEmhSQPSlm7Js/LK/sjbwxluJMtMJ0v8vsXdoBSXz4qqIRG6geaQXUGQt1sUS2WbVdHFATSLlz5oVLPa82gNRgFfQq1g1kEJKdLYC4VnyWAteO2uolRoVsrpk7XkuVkrCXJdSdmYKS+KuXiaVtk1HqQ==
X-Rspamd-Server: rspam02
X-Stat-Signature: 864ph5it4sqcrnmqq4zsr5j3zj185gsd
X-Rspam-User: 
X-Rspamd-Queue-Id: 2367C180006
X-HE-Tag: 1767094827-55977
X-HE-Meta: U2FsdGVkX19L0eFdlUOw59PxV3t0B8UFr+W6MTVTwlq84WdsbPumvYZckGtgkEFml3Q55K1gEh6W85Jtq4FvC/S1MYX47won4t7+fBZVPrhB+duw/NtNRq4utFAr/YV1oGPBXyQFnmTeKXnAGd0kf3F9o/EADauPfbRAVoZGSLT9WL4RssQMlS4EqR3RlYU44mt1XDIitfDMf1Ft85HCuHWbL7cQYpZz3MKIRuNAL7YzqVKJMqYX59mG6O6gLQyQLa2/mqWDC8YRjh5WhzdI9wBA4UXrpeAlVW9a+N6PvlSlnQtX9kGLacv/q2iKf1pz47RC8BRLLum2fAAeirACiJmibV4hUKtYmq5visBGykpRQ27ngT2KI723GOUaFURaWGshytZ7/c8vcUp/pMfLs8aY+VW+Os1TVXGzAD5oHtn7yjDih/YPDfOf+gZMLfuNebZoDI9I5QlV9+wHt/pf5B7fTIerVjJVtXxYPjfcxQHUYWHIQ3XqsGYD7Caze921Qp94ND0JRvM9x+4i6BFuEw7hl7t9E71SL71dIntmPJmCu+2dcmye93IBKO+F3PldIx8WnPMJsoGBzw+0U27B7iv8Ggns7MWRf1zP/hlLqbYiIyX7Be7S9+diu8v9Dq9lfM7BtfoDXimpoMcxMGYqqGC8fDteuxlDeyz+2A0fOrCCCFWvw9ZgJ7D+bRyqAHtwulTExI1IoECFEIdAWY8d/9uDea8AjosEDpSgESrrt1WUiGD+Wff/qMxALvUQp9P8bF80vN9Zq6st8WFRVTCV2JDagyLQafQibwW7xbHfekT78HXrv0oL2teSGOdybbJtrUdMuMxkWv0lBuCkOUR3Ltl0Z5JyxE7p/df9nVoWHHJ5phb3572biU9xzoEiMSw0VpHweZrh2E5KLPKY0+1bxeovav+QzUfNMKqmC7qnw5f8wHPAWCQEhR0CZHfrDkGBzuQABBSwwFC0Q7Sggtw
 cVsFKse/
 Cr56AJ0rAdN1oL5DEpQNd+lvSfv7G3q5T372BRjHMxV+9l+LhlD4sLEvHiAt7+QIU246omq9ZLCYiguNUGZWeHSFHArX4EndgqV291mP5byuiMpyl4gFehUZHbGLAZnJviAqY+t2IryzCQqJHAZRWotYmLVg446c9XssdDrssvNbWrxfuLjq5hRMNH8gIe75wH/CaX8XBu4GqsFjAxq0o0F+GefUtN6vABe2WaXnFw0w4m/oU+BcyuziKUkfR+Vc/4Q2wVRRmcta2nbVVQ9SGB4nrWBl3iGNQArfRUrFQTBv0e1Ss8I0mpIrdohIJtM/H0jc7x3eLfowoKAraUs9GKPAbG5qfoTtmT4z+oYV7zJkjJjbFPCdYwt9nsGBMH0GqfIyH/xWs2r8mubx/Hu39AnCKZUDAQbBTXkpIO9vJvwE8A1+lXSWgT06SY0/dsrhQEFuJeZ13G79xKSI7Akof8FINEU3M3L56khqCy0rIQrLiJLGRFaygfuF6VZXgfvFvRSuBUWI+DfaBhkp/VHtEYk4MZEO3120pDoKA8IKuIgp3itbCs9a2oennSu+HMiPbvPU7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:14:37AM +0100, Miguel Ojeda wrote:
> On Tue, Dec 30, 2025 at 10:55 AM Brendan Shephard <bshephar@bne-home.net> wrote:
> >
> > @miguel, Thanks for the pointers in:
> > https://lore.kernel.org/all/CANiq72kcMLXz=xyZeKC0=j_e0BzJEY3wGpBTTxfJsc6EZhCnXA@mail.gmail.com/
> > https://lore.kernel.org/rust-for-linux/CANiq72mLPvB_6Ow3bW5-V4-km=RyA59chQ1g1x9qUt2P-zZweg@mail.gmail.com/
> >
> > Let me know if this addresses the points you were raising in those.
> > Maybe you just wanted usize::MAX and then one over? The first test
> > case might be unnecessary. The last two do a fine job of illustrating the
> > point I think.
> 
> Thanks! Yeah, either way looks good to me. Personally, I tend to like
> tests that check both edges.
> 
> By the way, the original comment mentioned "overflow" explicitly,
> which was good since it conceptually links to the main docs which also
> mention it. It also seemed more aligned with the other two comments.
> Perhaps you changed it since now one of them doesn't return `None`? In
> that case, I would just remove that bit e.g.
> 
>     // Requested address causes overflow.
> 
Yeah ok, I agree. I like the explicit mention of overflow, and you are
indeed correct in your assumption for why I changed it. I'll change it
back to the original comment.

> i.e. I think it is clear that the first case is not the overflow one.
> But it is not a big deal either way.
> 
> By the way, in commit messages, we normally don't use paragraphs like:
> 
>     This patch is a follow-up of: "[PATCH v8] rust: Return Option from
> page_align and ensure no usize overflow"
> 
Ack. I'll remove this. I found a similar commit message in the history,
but it did feel like an awkward way to handle it. Noted for future
reference.
> Instead, it is better to provide a lore.kernel.org permalink to the
> patch or, if the patch was already applied, refer directly to the
> commit with the hash and title. However, in cases like this where it
> is not really important for the change itself, I would just move that
> line below the `---` line so that it is not part of the commit
> message.
> 
> I hope that helps!
> 
> Cheers,
> Miguel

Thanks, I'll send a new revision.

