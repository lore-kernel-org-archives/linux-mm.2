Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E601F3D5FB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9AD6B0096; Sun, 29 Mar 2026 11:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B026B0098; Sun, 29 Mar 2026 11:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7196B0099; Sun, 29 Mar 2026 11:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA13F6B0096
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:49:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95AC11A04BD
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:49:21 +0000 (UTC)
X-FDA: 84599534922.14.1AD9381
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EE037140003
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:49:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ER4wWjgc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774799360; a=rsa-sha256;
	cv=none;
	b=P1RgmmNvBdK1lby+ZVjYXFQHlwr7NNibzTBv4M1zLA+OwyxN1uHKXZ2Ihzp4bfUWo+A9jm
	gj5hlDt3OGlodWuUjpV5f5vTZirQZ8jKhgFq3IOqmDS1uKeKxBEBPZLGaQ7j95YGWiKj9w
	zEpCVX5WXCrjcZBb5HZ3cYkNArUpH4E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ER4wWjgc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774799360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KN4bleyxxI+iPAAws/OtP95Os5wKC7hbfS0qVA64OpA=;
	b=E7MhAv6m4NsmQhc19cDlHL1dxg1z4qbDVgjYaNtTSkhMEoC8uN2mz9qKY2+R9xIQHR/9Jp
	D2j5ttscZihkpPKNfay0IgXTDOr6GP3rNcm4QVNZKMF9KM960Ysp7u4ghWThdw0d7Lxo3/
	9DpJdNaPUK+bdUnrbHTXWXvvJK2jGWM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10F5F4066C;
	Sun, 29 Mar 2026 15:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871D8C116C6;
	Sun, 29 Mar 2026 15:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774799358;
	bh=6BPfdPDs7/l+xDR+dNdtis6DP9JbpaorqMtRKxNtuM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ER4wWjgcXPZwscYw59MA7J/+z6DhevaDOFlgQJvNWEOta4P1bYnMv80z3lJKkfVcr
	 zL7OA+tRbt6pZKJI9fOAGLb8RP5vDFBSmqQaFMkaQRvGv/8OMLzLiPzkg5ZI1iZqon
	 OokRBc4q3wuMS6e9nAyKX5h9wl8y0qXj7y/5/p2Z16+jEoEEROIttf6TNYIWFf1UPI
	 FcgoFP2iBp9/HmYX3EtGfaVPCGnTYCIMuIjjJ0kXGwagSLmOoSi5cnefcJIUTynL9r
	 WLTf8aMu9c5QA4l4RjCeZbyLDwdNsjnp9b9IVLVEHCchNBLcTWnLqTdz9eORWFmaAU
	 VksLT5PqSd6lA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn commit_inputs vs other params race
Date: Sun, 29 Mar 2026 08:49:16 -0700
Message-ID: <20260329154917.47598-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329153052.46657-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE037140003
X-Stat-Signature: xeo1sb7a8izpchc1wb4tx7g8n6r68mk6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774799359-57092
X-HE-Meta: U2FsdGVkX1+Y+p1Nux9s7LoTQ8i8jDTSBN9nAsBzdnyja5u86Cv6GiN/TZQ+TMzZ3c8Fdxrx4QJqFPIgj5MHsuNf/5ZpHbW7imx8OuD1eS/SF+yt3brNIR0IMjbXvw3xJQtlNtadJweHqrSWv3hjxAaXLWTdnAPhWqVyf66shxLBXegJZF0HkXafYecTN9V0selNE2yDKk5Fe94tkk7tKqSklXDmIuK8fKEqZfXeoVe7EhVng15Z4nrMkjF99R0ZxUTUjRP4xasEidRzV32u7RJIn699MmOSM2kJpc8NJv+xcfn+A5eo3reuQnhbe6i6HEPu+cgKqdgUNWU/dL2/CqbUNjSXEBf81LRTYRywNfWigwGNnpR2kCmn+ztjS6fX92texr2Pz82jVjWFafpPp6xJLrbsm22aECt9MJoU9A7AgstpZ6a9At1aLAHkfEbdNHEAqyZycq6Li1hfwhXHNRSfYKEeAj59rcbk6bqWFmBnqokQYQGhajfuUNW8hkB5DmtwS2zQnbGn4pslxArGBKC5t5NNI/y4OzeACsIC+nxBUVEa+E6Eb73sYVT8C/QeI0yfadsFd+0yFuls/lpLB2DqFLUP7odKa//Vg5E3+4TU2HNZG589/RftMJOmhvqQrXmGVllw7wGOaPlHlsKwObe/HXlmRVSwPC2tGX9XWR0uRJ6pak1GY17ED1oLnglmsX+CWRQKrwabCmbe6S74CJMwobi0An3LwytEppyiIWolihz5YeqhsalvlWZ2tVsE5HvauKMVJXONK+ok0lOgW7KQ1khWT7MXTWJ4YRHJwZbkTpl+UHKixhk6EPwx9z8Fn7DUjNGT2ExJ3PllIrgdyTVeqqgxB/6pH4m46eAaT4Rjl2MpDSbWZyEQ1NUhfpnqmON/jk9qFT+9wHV2vUVrjN/dWB5uVkXvM7/sojPW019qUKoKSyJLDGOLjPn3rRiPy1czAKdTj/RUST6f+GM
 K05qxZEw
 1P3Ssgr1mLVF0a50FBfZzm5XZt7haaZQ1Kcu0Rov9CNmSZ/vlHP90DY70Gt1SHkwlDiRu2j+HpH2ATs20LjnKNeMFbmua1Yhs3puscGGU8dUIvZlaRFC0KJWyMly91yQI7Ubad2hPZGTdDMlwtjl8LuixkYZ5KHA8OBCYfrq2PhXCsSpPMmospSyCdfnALeJTTmBcSaifaNOMzgP+4rv5y/XhwjLEUgz+C7h2NHQ48qOGsqJtroosZ06JDO1UQcBYpn9K3x/ZhV+7x57yiH7M28QDE31HRflQ+4IB++GCDlOdCtfaVvea/GbZbxPhXSQVqfN9eMOZd9yZo2FwfYfqPsoOfjRPpYSv6+vtzFbJlpFGk8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260329153052.46657-1-sj@kernel.org

- [PATCH 1/2] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [PATCH 2/2] Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
  - status: Reviewed
  - review: ISSUES MAY FOUND

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260329153052.46657-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

