Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CB3C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640F96B0096; Mon, 10 Aug 2026 10:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619EA6B009B; Mon, 10 Aug 2026 10:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555CF6B00AA; Mon, 10 Aug 2026 10:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDFA6B0096
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:59:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEFE8C01C3
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:59:21 +0000 (UTC)
X-FDA: 85085668122.28.32FE95B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7E02640007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:59:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ed1az6VB;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786373959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8qxlsQGfocAVe55+yk0uJ2BiMt4CEd3bRCiLyYXCik=;
	b=DXSj9G21XoQqBPKaivfGuTumrQo0NTVumN9yYHM7cqhn8JSO5l/zRmkq5N3eMbXHZAQPah
	JcYE1r0pp7+0Dunz2NMwaqvwfM5KPx/lw1YqhnQnJ1ph4N3BqTITEIoamae4Urbt8vzBb2
	ERWi6E/YksWtFJxUPlKYxk8dqYWa3HE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ed1az6VB;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786373959;
	b=PS6pguRLz5cgZpH3DeJmP2LzE77U+FjZCvnGvESrNTHENsfW/C1BIqmeXzDuiZhT0mzlk9
	KKAbmFz+rxXzPaV8jgPjhGMWO70i0J1TStlwM+LZt2Onyih+S/WFCnsS8CZcKQ9qvaBC3f
	xvje5ISbVsNhDR65E8ItJUq06NbA7H8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E3FC60A6E;
	Mon, 10 Aug 2026 14:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8836D1F00A3F;
	Mon, 10 Aug 2026 14:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786373958;
	bh=G8qxlsQGfocAVe55+yk0uJ2BiMt4CEd3bRCiLyYXCik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ed1az6VBryFOclUxePVQXHfbm8EkIKq0m531FGOOi35ufllzQL/hX7jG+ggcsnPNw
	 odnCpPptXhxfAUXYiDM4bJFRdmPtWX11Mx8NacoRw8aXN8wdedn0ckdcGF2KtBmKTp
	 rHNDR/ragt/P4AYm7YyNELZpN+Rp5s0uzsCPTTIAu66x52FeueOZr4vFSqIA6F4liV
	 JM5B9JhtCf88sJ8xHqB6Bxy5Bydi4NvKwbXcl1RY3NkPXzHemZ/2VIWN9YkBntSF0K
	 UvjXhV6zx9S5wL983zDyho3eMrwObwWVV2f96xXQ4GLfK5DXYcgAGVDqQg1uunv+Pr
	 HMjsJxhIympJQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id EC9F9198003A;
	Mon, 10 Aug 2026 10:59:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 10 Aug 2026 10:59:16 -0400
X-ME-Sender: <xms:QOd5atYziGy39K7iVg7BCTVaua7d8AREYBaHEMok9aa5uxmrqWnNGQ>
    <xme:QOd5ameZrEHNIyi6C31akh0OVg0TlBVRKJdXOtUYtKogdk2FPR7ivo1wiH23rWkgp
    XmrT1wrss15EKFhAMnGxxxDTSk7H0RKYHd5aZcvLcbCjNluv8h7q1aD>
X-ME-Received: <xmr:QOd5auHgGD5dXs669OKKu1Qgx6Q7b-GiPslvqPmRUw2g8EH4SwWfXQZ69nQ>
X-ME-Proxy-Cause: dmFkZTGLf/eoBsdkF5Bcv4i7XrYQoeSrK3kmL+XPu4kKdoH/000048y7ntGF27Bp8G86zJ
    61kFC93E0uHN1m8C0YxhAmgbvmZVRocMALRmYBeYMPOD1xgiHiinUgvyLh7d2AZ3Q5s93r
    URRyzhEjgZoCXP1+mEzRrrpgm2DtGIp1ZL6f0s1WZK8X5TYxrP+S3AkjBJcT0aQ3IgR0Td
    v/a4rW/kNt1q5C5wgy8OTpNWoHkcat9Qw++32800rNwaVCTlroIiVyydmZ+ZpUQ5KpFVZM
    KYCDYortVruTL+CpAbfIFB8R5NjDJ6U0KzbTk0B8VAgarQtGQqfjLQ8kqllbd+yTpVdseo
    KvpPzjwxGlsZW60IR2yM418qTAMpqFhNEg/tuy0Dn+XmEbRVMP6/+ZB3GuFfVvW++PbibM
    JOUkAnt18GAyHFmdEHjN2lMD6Frxz+kRwWuXhvFxrl9CqKYyCR4ca7LWvx9FVxRKr7IHgW
    vIPE90fcOUe6BQregpLdSkGMmHGRgUjR88QTSHZDZFw20ggV8Fmfh+K1iLvH6K5M06z5ZI
    Z/fHFkQMgVLtogPE8JyJS6geTi+w3zxwFP5YePeB3O/9wKpEyWWs8uIUIICrvEBMy8q2vC
    rMM/uDBA7WXR73QDimpl3mnzuLIexgWC5n96u/rOTsu0LryWZR++4rBxDdqw
X-ME-Proxy: <xmx:QOd5agla4-MDqvktXTsAEWhrqY_VgPi_52oV5X1zd5ipPgLWqrh-WQ>
    <xmx:QOd5alPJD7RWjEuZFR7z_kfin96XP3adnltkq_i3s4vklayBbMZj9g>
    <xmx:QOd5arFMQT--skaKz3KhiejvoDye-RZ4a_8JReHVFimEOD58Y1kDFw>
    <xmx:QOd5ahs_Ie_63ACJvelrLQRHe6L2f-seRoNTPaxxI40dSRZknG82JA>
    <xmx:QOd5amSf4FW-maIeeMu6GEMZR4IKIGHhWcKc06xqfJdYxvrqknRkq0lg>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 10 Aug 2026 10:59:10 -0400 (EDT)
Date: Mon, 10 Aug 2026 15:59:00 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v5] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <annnExUim_y99PrO@thinkstation>
References: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
X-Stat-Signature: 314uh49mpmrd4utsq8apbdiwrqi9t1ym
X-Rspamd-Queue-Id: 7E02640007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786373959-343050
X-HE-Meta: U2FsdGVkX1+CljlefcxmZDJmultGE3lKODSK17WlJJT0ohF/Imu5CU8N91uAtNcCDoaHcAl2ruCFxEQ62Nq0X9AV/JMYi/QhRiTTMsDy8sg9amwlyuAfEj+jn4izIuA9dqooPDkDcXSv3UBJF66TI7hchDrdgCcIN1Oxl7zb07C4Y373YzZVzN7rd2T4PS1fWy79cfmNUEPC7vri+9ajvvMVmSZ+6k7l+7YEs76G1GhllAbfUUSKglrFk7wjk6prpP36HSeCw+FiOSaAv1+S1MFr+n3o+kVbxX6Wy/dMi8hZvtn/B4Lap1CAL0RTw/txdqmLdKEArlkTGCpqCw77tHCDNWHM5Nx6U1SYlCOLmXh1lwXp3n06d8f3zPEEsKGgGUKsJZ2ATVFn/O4jdGEBIFrORaqUKVvNXZ6G7gviceC5ZreLO/Sg6ieyqgdiOd9JD2rI3cSk341Ww2waXRLoH27ycXgsvj88XRFbdGDEwth3b1pYqgBH/863xLRBPbjKnsJ3NGrau3wOmEI3p6E0kX7SUaO+UUus75a9otGKqquWBldSAWkPHteSQ9NSNbRsWuoMDRoxg7SjYyIG5hQZVk4wYQb+QDqMpFb81X7JsazrAZHrtkdRdQ+6XcrmpzYApmojlo0sl7hstTWxXAumHhXa2w1woEQ5UoYPmMfwIyGzNaXpuE2sGGUtRxeRLzo736SkhwZp6M5ylDP4GsZ6cuUqgpaQxlnadcMnN3K6wWc2xPKkm1U2ynmlX0sKhXoPsIZl06pPWcgx7YA0AzrD1IkGvfEQGa61A4Dlo8SGuvcYd2LuecKf+rHuq2EjqsEOMdbhmv8G4JCD6JS5Xla5Qd7YGrhvNK7PyIRsQCBHx2wTR7NSeLw5DpbCOuHg1HqNMyNl99MLK6xtCOLvlMaWOLXzLCCoq21XZLGZk5jC8zpJrHTu6kRH09zefKTbA04ZQ2yE+GUe1RbHmHQxHh7
 HN/prThe
 SO/bUuJRptfv/sAws5YpplCbF7A142VsJdHEWxUBqTCiqODtXdH2N2Z0dANOtcbMHiLWG9NsnzZOq8KJepLHdmcvtcrItAfzV2Uw90BWO+bPx/PUkWbkpVVf2G8TonMJIZKbAGY1QQm/lmNy/wh9qvpDFVxz8T28+uH2mLiup9qjjA3MKPwonaQ5Dw3wSVUm/UfsP/QDgvN6RK3Y9hzYysXVMGYYLqvNjcHUFT3g5m5RjL4UNWgaH12XWKiD+/085Qulf4Hs4cLe25eBGulOLuaz9WXK2LeZKUyvy3Ka9XKrCzKUvh7fZwYTjD+hhjzjMUUohm4tB+3IdrlHqhFZH8ssVH14diiNwkJlyE4CV1KxexCCIm1o49sAs8TcV6Y9zmC5//pnnJSPwc9B8vb5JhmYKJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 06:32:04AM -0700, Breno Leitao wrote:
> Memory failures (such as unrecoverable ECCs errors) are getting more and
> more common. The kernel knows how to handle it while running, marking it
> as poisoned (and SIGBUS user tasks).
> 
> Poisoned memory is removed from the buddy allocator, but, not from
> other places. A current problem is that kexec will load new kernel
> on top of a bad/poisoned memory, which is undesirable.
> 
> If the next kernel's image, initrd or purgatory lands on poisoned frame,
> the relocation copy writes to the bad memory and the machine checks
> during the kexec.
> 
> Skip hardware-poisoned frames when placing segments: check them in the
> kexec_file hole finder so it lays the next kernel down on good memory,
> and reject a poisoned destination in sanity_check_segment_list() for
> the kexec_load path, which cannot relocate.
> 
> The two hole finders walk in opposite directions, so each asks for the
> end of the poison it has to clear: the top-down walk for the first
> poisoned page in the window, the bottom-up walk for the last. A poisoned
> hugetlb folio counts in full, as hugetlb keeps the flag on the folio and
> the poisoned subpages on its raw hwpoison list.
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

