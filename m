Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B94CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358496B0005; Mon, 25 May 2026 10:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FE56B00A0; Mon, 25 May 2026 10:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245A16B00A1; Mon, 25 May 2026 10:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 142EC6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:59:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D74D91A0137
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:59:25 +0000 (UTC)
X-FDA: 84806250690.03.145A1F8
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf24.hostedemail.com (Postfix) with ESMTP id EEE5E180006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:59:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=vzODRWIS;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="e dH8wDy";
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721164; a=rsa-sha256;
	cv=none;
	b=V4vNfU9BRa+Iae4u5yQVB5L1PDkdS61YK4469mSWsDUqiukwK/qlYc2DYZ7toX8FFdzoLg
	gfYq9jRVKl5GOdMwSP3dbrn3nX8/NhXYQWRSx3KWQZOxn3YUyXVUrHQGHw8jLI7Pgscq2B
	uz3KWL4f/V8a9KitlVRfrtUuXJkgU5s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=vzODRWIS;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="e dH8wDy";
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJcyea8FszbnWyZPO7/4y9oaI+nlsbVbYe4HMnYbIek=;
	b=IY/aFWG2YskZfLGbSnaws8ZgIb8UfGklX49H0irQwhsFGQYADsTv9BETAG2bFzUN9drbbo
	Xs8K7kXRy2v1v1JwKDANPeaVMtNwfhoRRFFSNL0TnCcyiQQFwvAZhddL6UXVTcF+5hUhkW
	n3mRNJKlnw7jhXbAikv1RzWI6YKvo8E=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 9F1451300501;
	Mon, 25 May 2026 10:59:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 25 May 2026 10:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779721161; x=1779728361; bh=uJcyea8FszbnWyZPO7/4y9oaI+nlsbVb
	Ye4HMnYbIek=; b=vzODRWIShDzqA2wIcanGpJjCOSLV0zb9pet4DC9Ngq8ac6p2
	EtRWyExyg5r1EPANRwYi+Cmtdj0xF066RV7zD78EJriD3VB/X/FoleJHxI3iM5xo
	dyGNx8Kz6kcCOn6KTfK79b+0lVKGPHuVsXSsFYhRRHHHxjJgU1Is0R8tdycP9bTs
	okPZkunGcY+2T9w8wVksOyt93fHsMNDuYotBgLAW2LcFilmGFuKUMP0klj3kOMr6
	T+aUvD6ZAnYqARdUmFXOwqyZAJgpgLLjo6qY8O6LHXCIuKkIyZDgANuxPIVK7kNe
	O8SzRDwEkX41kPAjKQLsXxY4oaNfemUzJZ4QZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779721161; x=
	1779728361; bh=uJcyea8FszbnWyZPO7/4y9oaI+nlsbVbYe4HMnYbIek=; b=e
	dH8wDyiN0V03aE/crXn9cpYOuiAAgTAh4FIR7PiKIN8RRYz/y5wfcdaS8QuOkXIc
	JjNQwSmnBJCH/a0iEmGedYI+UC3QJMf4ZFx9qZ1Xtkr4mkLtPRReoF6C4dbgFTmc
	o2/4jKKpfqrlakSra6decTnHEZvoolwMur+Hxd7zt12x3GwUqTqFljBQqKWk6fuF
	S2eoyfROjqFMlk0SvsT97RuoT+3SnrgV470mitd8KhMXLtWeumBUliVZ5F94LyTV
	/G/4Fawxwzwqe+wxCZhmDOncF+S4gC5FiRqIwdFINBlPbXgcnaOfEKzTKnMpPLqu
	3TEZCBBvAO/Oirk2ik6mQ==
X-ME-Sender: <xms:yGMUatWE-s3RE-Hp68zN3HHktCxPq9yYqYEEtgBSVRa19kCFSdY-QQ>
    <xme:yGMUangylZLSTfnZ8W0BCB-Hau68xSs7jcGysLCIYrEHzJxH0YehCLT6lLe6djvN0
    sm4n1wLs2_7rmxKuahzPtXggtLXZuEpCuETBT9nUClUkKpfeiuNRg>
X-ME-Received: <xmr:yGMUarRWXSM2yk9J4cSt3WbcJJ_wMTPNWbTtXX_vA5X93jEnWt6QW4USl-awLw>
X-ME-Proxy-Cause: dmFkZTEJjh70p+L5wV/erRevkiyg6otcc/PUgcMz5jGp00GqFmwb5PGsDGSnx1zvtQTsHV
    8kti811nWnmu3JFkW/YEZvGLc5svfAyVr6hjJNw1Q+INNTQIq8gztfZ97xuF5KzE+f1/rF
    ocRemqt7YDEj32fZ+jKcTb088tE323WwLDIfIQUN/KOpr5jv/734Ph88g8UQuAGGQtT5E3
    zNP0glrwHgjHLOijKqVUCr2AolVr1e0oHOFEP8Vp4GaHZ/KNa2CjbX0aUspnArEFdBsXeY
    oza4f1wStmf7SlgWO9qWSc7040wZajc7Fys5l5jE+HMsxm01vVUyHACUyjUYXYN4QixCSj
    cQ6FBhsxOalHc4v/dYw5N0tQ20D3WQDQKaBI5KoEHe0efKgRKGZ8f3rqXGjnCE1gG5eNFg
    85TsuHbfKBueOei65zAPMuoGY9hLqEgeIQkHxznyb0r8u13SEZ7Mnd0W9hW8EVzvNbgu6G
    zT2XcmLw54RVbjuWqJPP+ol0xcrcgndbETKiOnW0SHzmpVCrRBEY5SykxUbxSGhjMD8B3l
    ISWe72k4h4wiQDjZ4R5GlwUdy4mWSeICpB2Z9VhONd7R+oBKkb7fP8iCtSdMzLlUU+lLrO
    zOj5YIGLychZMnXMjMWKdu4hBkZUgvmbZXr0/ob5cfqMwYSoVHxC2AgLdVdA
X-ME-Proxy: <xmx:yGMUarwhm8ZlX6TSjpbE9A7BLn6tCpnrNYVaST4bjO_ODXUvhXiJjQ>
    <xmx:yGMUag8lCLv3xmxGk4kmyD42l7wp7ClAfpZ1MHK7IYgaPvXfyuarkA>
    <xmx:yGMUatYoJo6DGzSk9u4ZVUvxKVyXa8zdxH6KlNkjdWuovXbw8JRzwA>
    <xmx:yGMUat6JqEMmcVrovhF86sU72wR015nVrX7dIgkjNlkBEGyZSP8tRw>
    <xmx:yWMUaj44x6uj0QdlIxMfh8b8Qk5bcka_CNnXBdsAC1LznnD9RZHYQdJP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 10:59:19 -0400 (EDT)
Date: Mon, 25 May 2026 15:59:18 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 04/14] mm: add VM_UFFD_RWP VMA flag
Message-ID: <ahRgKh8kZJ8z-huA@thinkstation>
References: <20260525113737.1942478-5-kas@kernel.org>
 <20260525121916.831DA1F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525121916.831DA1F000E9@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: EEE5E180006
X-Rspamd-Server: rspam03
X-Stat-Signature: jbzjm8zz7ukwtdighg6q9zu1bubdwrqd
X-HE-Tag: 1779721163-198599
X-HE-Meta: U2FsdGVkX19Tranpu0MX4X3MUZOF2WuJsY4EUWKOdmkJapJoHNCUbEnk/HljcAeQQ6dwIVcAwtWvRQ3gFSoyKs2Bq6OS8yELbNjBlLpcIE+UKGAOWNk4jp2FxgLlFpqSVJi2JftJ0CRkA7H8xkcpdwvq1XJWOmBM36v3JizM+LYWD4whMOBPH6Ons9F/hKd2tdv/rEKj3UDOc0RZ/kQWIHMH3z00BL3vsIoXmRuX7aX3D96oWHu10VTrBwWcDnfGgb7gqxpHFe7hzfukiCpP6QV2WoJhlPjEDDj3bBL+VnuTYrlFePxO5Hs5CF7aM2zJaIBr4METaa7krVtriFto49+pmTT7s+7b0bpcMUGEVOrFazXs9EQ7J3eR2/h2hhW0ZxSBmJp6k4GQBY+cDSyAkw741UQcQSPqxGpBnLMoQPGJzb0x/U5l9d/YEMBfRFTyd+/EUdwVAfhZWSeyVk9lOAd3d/hIf9zKUxNii/0EiZfouLSA59knbQqxpxRCKD0DzmmAZYffwJm9sEVJL5BHZ5j/3Q5uOjQJcRtKHDW2GKXqT6tRuk0pYJ2Aowgn1MrRb4jtITTbUk6MyFUgwdXmfvUwYY2FpLZ8jf19Xo7QN1aiwWSYGkqQrxoSyb5g95cpKhU86NHV4kgzs53ATd+Ugbvm6nuS6TazDPcLM3zrBUcTAXpxAVwya1rTuW2DpUfVM16nzjcwb1KKBEOe2oHOim+tSv5rNdjQ0wZGrzXU+1NIh6GBUR5V1mGPBhCmGaqm0X9c23JcLzb/ImWQMWD6f+xrejlZCTezDcwS03OqzyBbdzdwHHPcZm0ZQUL+IpHgfEg8ZeUPgoaQ+6tZZnT9th9gYSIjsRIcsq2RmyDboek9CjB2Ei9ZrrGK63+EgBUps5qG3URdeeFEXqY776gc5jzOG0PdEV495InbDJgBFxyjn5uEPyB/9B1bC4RGVfTSi31A+UfW0+q/Yq4uvPe
 GCDskcyp
 511p9UwNv03cV0Qfetffm1MGMaOGPd/acTzv76ICqHlAsX/IqMfaqMsTOtZ8rRwnyaao1jGNCqDFULtdCTRBQkkLhMUfrxlWJEMHdpXP/QqjclcTZV7jToPfP3afuM+t8ObxcN7ZTbFbFPD1aXPvAv/9XpuDR2ydSiNyIJrYypBOgIIa9xdURHR8aCo5jkLjOb0vdyFpawGYqfyRdpngMIFEShpVfc0YiIWMKY57Ts6USrLyY5iw6nvvsqV/5osE3/1HoUB9Je5MwHDAo6RLeRG7FbM4+IO4IRCuy5wKXVYX7BiWfBv30ZE2sH/zCyzc34RUMOs3DA3AZzHcLXcGVp93uBnM2BpW5iExNimn1nOfC61Wena0PfrY/CVMMec9VWi7/Ccq4aKKlOrBTzikuY4kKEQTR92kuR9mSjgJr6Or1DEn/XRcHoR94UG+fsDHGdgqVl5UlcEOte1NlQkt13WrBSDyidohtdKqjSZqBUvXfcbUNGiwnHWTBsnpnhbUlA8UulXGMh5b2U89YUEIy6FCcLfvNlEJQmTN6hv16UtVhFWrgKL/Hbadj8VY6Ab2UCf80fQ9TrtF2w/PPIyMDY/WqzRzqBjy4FlZw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:19:16PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [High] VM_UFFD_RWP is missing from VM_COPY_ON_FORK, causing silent
> loss of read-write protection during fork.

Already there -- include/linux/mm.h:

#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
                         VM_MAYBE_GUARD)

> Pre-existing issues:
> - [Critical] Evaluating __VMA_UFFD_FLAGS causes a stack buffer
> overflow on 32-bit architectures.

The VM_* values for the high-numbered bits (VM_UFFD_MINOR,
VM_UFFD_RWP, VM_SEALED, VM_DROPPABLE) are all gated to VM_NONE on
32-bit, so no 32-bit VMA actually carries bits >= 32 in vm_flags. The
OOB the bot points at is in mk_vma_flags() constructing a stack-local
mask, writing dead bits into bitmap[1] of a 1-long temporary -- no
consumer reads them. With __always_inline and constant bit indices
the compiler should fold them away, but it's still UB.

Pre-existing -- UFFD_MINOR (41) and SEALED (42) already have this on
master, RWP just adds bit 43. Worth a follow-up cleanup, not blocking.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=4

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

