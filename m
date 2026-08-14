Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B35A7C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 11:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA4E6B068D; Fri, 14 Aug 2026 07:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9C76B068F; Fri, 14 Aug 2026 07:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21A56B0690; Fri, 14 Aug 2026 07:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D177A6B068D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:23:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64A421C1640
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:23:56 +0000 (UTC)
X-FDA: 85099640472.21.63BEF1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 703A1C0003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:23:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NZwVPNWd;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786706634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfADc6/R72hwdaY25fr6WLriArvVrwd+ff7yRnwVQRk=;
	b=odre5u42LKCOjwqtFvO33NQmSjKG1gBhLQVaQqwQYmHLrKS/HbWziHYZ0ZUBe6YdzzQUT0
	nlAPUQCGYyxLqjQiAi2mZhDet3P9kDiXhtSOaUeJh1geUM3DWl/F20tiCZsFBeaN15IXKu
	ooe+OkVNIZhKVUCQ8ZDuR41DS7EcUnw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NZwVPNWd;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786706634;
	b=GZ0Lh2Cnfa0APS5yVbEEptjInCd7Avdu2ukNVGZ7Cp02N+S25e49+guDVya0JhUq9sL/Qc
	3JtCigvrDuXCFWbAs1PwWYeoou0EV/xUWniWN81RrJlEYinvBTYZOP/74WrxSLsYMf74j2
	Ta83WrmCe0qr+PNLxOLdLN0Yb4zZDq8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4588743724
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0711F00A3A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786706633;
	bh=rfADc6/R72hwdaY25fr6WLriArvVrwd+ff7yRnwVQRk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NZwVPNWdgl5G6msuqZL9Mkx1Bop2gkMomPd9lMJEeesesx6ly6TLavXoZW/bkVkek
	 HYGjgpPPIA5N7evtMozSBVC3pHLDLs+zGvALr3Bledk8VgcnNZiGIW1+5+heax77Rz
	 3dSenU7yBh0xYNLUZaBAMkJ96NpwMBQh135gaQ0FMZ/Ne/rZ+CeXGbxnaBbYOf0Ld+
	 MlrlOSXDPXFvHs/HbpjNli1SKLqAHV6eCt6z8OiKn0bVFID7AfBBtOJrCMMwfE7Qlx
	 2KY5pVL41kHgFKxe3QgvV7IK304Xb0eTfd9e7x8UMIA3Ltqdb9QFGRypCM6L8SoNmB
	 S6S5YTyV+zFHw==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9349ad9c857so95997485a.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:23:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoIoZgClpaNNFlBLIzC+TDyMTKPHkpWWfeSBVsHMvumuU+QRZVLO9wBobua/9sDpJL3gpUIU1sHRQ==@kvack.org
X-Gm-Message-State: AOJu0YwO2orH7z2fldo0QUqIZA/9uGAEZvbx1Amfu2P0j1g7A2uxsxX4
	dnVNY3DkYfmbzNy+Zn9dQuWR2V7ctNr9mZ/Qpsdgojit9MzA7oyWEoMGYeNNZST9vuL7Ht8bJop
	9w9L7oYZY49lBp9+hel10g29fs5/OBmo=
X-Received: by 2002:a05:620a:45a0:b0:92e:7533:ef63 with SMTP id
 af79cd13be357-936d2021e07mr461450885a.13.1786706632605; Fri, 14 Aug 2026
 04:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260814074705.939721-2-mambaxin@163.com>
In-Reply-To: <20260814074705.939721-2-mambaxin@163.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 19:23:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y+kGUH7TjKEGU+hbwCotHeubNdbJtoBExP+Ya-Wf3fWA@mail.gmail.com>
X-Gm-Features: AUfX_mxn4RXlpo4fupbSBD57H9Nh3esjr7Y2wqN9hyd0KIKiCgDKSWpkR8DcuIQ
Message-ID: <CAGsJ_4y+kGUH7TjKEGU+hbwCotHeubNdbJtoBExP+Ya-Wf3fWA@mail.gmail.com>
Subject: Re: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id
 on swapless host
To: mambaxin@163.com
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, 
	david@redhat.com, v-songbaohua@oppo.com, hughd@google.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	gregkh@linuxfoundation.org, jose.fernandez@linux.dev, stable@vger.kernel.org, 
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, Kairui Song <ryncsn@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Sasha Levin <sashal@kernel.org>, 
	chenxin <chenxinxin@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 69n3umqqxejytgaimobbgg9s1frdcty4
X-Rspamd-Queue-Id: 703A1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786706634-480439
X-HE-Meta: U2FsdGVkX1+OFItc4/mMJVN952jZ4AHWWKJTg21zYBzvYKFXiF33CevtHHNROq5I7viBYLyE+02dIBi02GfKBRiX/HVzn8NP80LjFoQiyQsdqwpUW5I29nkkjeXyYAhpmJjE1ZMejGc+EPWGJPkt0KYBpVrBPI8tFVvQVsfw66CSvFbxSI5CBV1V3gv5/eXJYd4g+j+EHmRHafclT5QnGfY31k8/E+5DFKG/Ap9GuQNMc2vSlZmB62MjAQFEqFhIDQvpYnkSGU63u5wGJPiwot4GVhM/itgFbSM0pkb/WunjqJMcr90sswiM8Vq2rNOewKcFUI74YCRvR2N8sJ4E0cIgs6EmcH5wNl1SnZ9vPLw4uOgxjw6lXZl0o8//sN9gothKk9SqDLkpntGObj0CB019MwCO/S7+qNMSHhSphZfCk+G9D/0Lny6wmWuomBbMpk5PPrJhu9YGtMP00LfLivEA4dd6Tkhgu07KeKBKPzTo2fCsQzI7XkxMyNTfKP/y57bCRXSAA88QR8r7eK8BOtpB6Q7Yfnu9tz/rfcmWjC4NyN8zCvl2wE7Oh0uIHPfX6K+No8UlQy/b0GSMd6PCkKYgkcJRUViuAcqbc4fluD4Wwvcn6oNRcniKoXA+eIpoK1DVFTy6yDD/HoDuowF7XsqnC42OuL+KOo08t97RTYTpXJNzaMx1yYcFlnur3k+0UirzGwcX+N0v/cAjUxX0CXjaO10vvlfpYTZhUv4TjyxsM+cWNcJrMyXymFw+3SKLJA1vw34Yu7lHmJDSAZRY8HgQ+MMOJ5liyiIBeNFobHjDEXg4wG4rB2JnBqaDI49Q5gCFnQ0FLqkc34vacNRU4ejhdZm3NctjPfTx7Sll3wvm+3DF9fff2pWaEQHVthaqUPn4TPqXdqa4uh105RrAFuxCfWV+7pOx+AGDHbXleGnurEu/nS/TWHZ+/ViELygjXeUlYtXORa8iom+XFBK
 BMzfdVAg
 J1Z5mTix217jz6Hbsljs2JD79O6e6YIVj+/UExFVwM/PbXXvl8eiX3tEWsLc0RIRE7pCfkBn1cnygh/ej1mXYafE2uo88h8iynVEotj6IrmInunO8ZBlmNIl/2kyRRJo0uYHhALJ69aYfFHuAWTkcYk71qN/hsjza+Ox8qwJwF9uSJJHW8o2pwLvLaFPF9zN11OB4HOkN4hA1GwvlhuzxxLz6HBG9kN7w1TqLTIbGMxOS71/Jv06rBUp21Zz173MsivTTZ7khnTdRnSLUV+5BA5e6fzeDGtaZ/MpvJ0Hj4YyIMGEVG3YSNM2acSOuGXVX/lvY/ZShZFEzjjbbfNNkOEC10iL/hsH/zBXVP9gmDLL3EqLy5OSuIresEuqMEL9/HWcUCwThNe7sBlrCUYw4Eh66QBk/M+H6b1bTf6q1/AzoZaacNX23EqTSMLPPHdjMeU1N/Wn/rP5apu/C48EJ69218fwNM14Ghxr9MSWKcpc+gBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 3:48=E2=80=AFPM <mambaxin@163.com> wrote:
>
> From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
>
> [ Upstream commit 63b02a9409cb5180398491b093e48bcb5315f5fb ]
>
> lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to
> __swap_cgroup_id_lookup() without checking that the type was ever
> registered via swap_cgroup_swapon().  On a swapless host every ctrl->map
> is NULL, so __swap_cgroup_id_lookup() dereferences NULL + a scaled
> swp_offset().
>
> Since commit bea67dcc5eea ("mm: attempt to batch free swap entries for
> zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls
> lookup_swap_cgroup_id() on any non-present, non-none PTE that decodes as =
a
> real swap entry, without first validating it against swap_info[].  A
> single PTE corrupted into a type-0 swap entry takes the host down at
> process exit.

Thanks for the patch. However, we have a strict check to ensure that
this is only done for valid swap entries:

static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
{
        pte_t expected_pte =3D pte_next_swp_offset(pte);
        const pte_t *end_ptep =3D start_ptep + max_nr;
        pte_t *ptep =3D start_ptep + 1;

        VM_WARN_ON(max_nr < 1);
        VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));

        while (ptep < end_ptep) {
                pte =3D ptep_get(ptep);

                if (!pte_same(pte, expected_pte))
                        break;
                expected_pte =3D pte_next_swp_offset(expected_pte);
                ptep++;
        }

        return ptep - start_ptep;
}

I don't know why this can happen on a swapless system.

>
> We hit this in production on a swapless 6.12.58 host: ~1s of
> "get_swap_device: Bad swap file entry 3f800204222bb" (do_swap_page() bein=
g
> correctly defensive about the same entry) followed by
>
>   BUG: unable to handle page fault for address: 000003f800204220
>   RIP: 0010:lookup_swap_cgroup_id+0x2b/0x60
>   Call Trace:
>    swap_pte_batch+0xbf/0x230
>    zap_pte_range+0x4c8/0x780
>    unmap_page_range+0x190/0x3e0
>    exit_mmap+0xd9/0x3c0
>    do_exit+0x20c/0x4b0
>
> syzbot has reported the identical stack.
>
> The source of the PTE corruption is a separate bug; this change makes the
> teardown path as robust as the fault path already is.  Every other caller
> of lookup_swap_cgroup_id() is downstream of a get_swap_device() that has
> already validated the entry, so the new branch is cold.

If the source is PTE corruption, I think we should fix the corruption
itself rather than work around it here.

Best Regards
Barry

