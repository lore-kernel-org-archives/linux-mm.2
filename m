Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB42606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c0rclIWE
Received: by kanga.kvack.org (Postfix)
	id DF0B36B05B6; Thu, 26 Nov 2026 21:02:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC94B6B05B7; Thu, 26 Nov 2026 21:02:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7D26B05B8; Thu, 26 Nov 2026 21:02:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6396B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:02:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15D38A54C2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:02:13 +0000 (UTC)
X-FDA: 85479248946.05.D104E91
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 130D82000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:02:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=c0rclIWE;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795744931;
	b=rLwt5HsaS80nk2PpeN775x1Kzhj5Uqj8R62DBPmf/ryujt2pAy2mmtJuLugeNr45xU9JsD
	9wdPlBU4TueDjZCm/1rqMvihl/kLQqdt8Zv74hMIwb9ybvvmbkxjfc3eIVVnsYQabOX9XG
	S6KrwLgNo7Y07QCsTkhpP8eOSsasEyc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795744931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CD6edFGqmU8n4mTR3UtP0gostgp/pYDUUVhaESpICv4=;
	b=kJWdkV5THEdvobif0Gjn8G5sDhtbBkwlgQwW4K/41CtEE1LSi0S8qKj/r5Z0toyqArNKuS
	qTuLYtFpJjT9Q7LvzOV7wt8hSXB7fFFXzyxUfBe240Tl5QVLM31bDDPnRgZ/BAU0Q5Qg4T
	l+DetdhidhZvMBcf6c0qH/vMmv2p27Y=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=c0rclIWE;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c51a14bd405so354019066b.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:02:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795744929; cv=none;
        d=google.com; s=arc-20260327;
        b=Y4VeZZ4v4UGbHEP8qStNYzJtZJxhX1JR8NidpQbAosahgKvj3olJQUIAhjBqIcKRDv
         3aZWVZn0XgeD4ih0vUMNnOCtOmy2q4z3pACrYWQL1bpzD97fRJtPH4MQZQ2r4GGl5nRG
         xN+BJYA1QhfJyoV7qJrb5GcKySfeSr2P/rr5uUJOX1EjI606cbOtzxha3kfI2IF0vzg8
         wZkLAmla+J2egiCLlVgXeZEWhxsbUUXHnFXV0r5MCDq8nLjRfds6Qcpnxl7bzMLIbBOr
         /LJkOdDTiR45ilLx7ji6J6GV3kIESvX5qFfD4vh24Zcqm3UujecrR9x5X12yJDLDHDiK
         KTNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CD6edFGqmU8n4mTR3UtP0gostgp/pYDUUVhaESpICv4=;
        fh=SF8KK4ZdQYCQpEEpwptJJUbIGoKHkDvcyMLTSJMR9TY=;
        b=gaIPJtGcgED/Y3G2OKcargC+CZXXf+Bpu8XdlFJ9t7YjUJIEduR/2YGuK0EoyUKEZJ
         ArSu0KZwYDEsfTSk7NqkfPKBBK6DX9HAW05xwowfvG6tjL97+ZOVkKmB337nIMURAGhL
         IAgIIK9Lz1QyigbGxS1Maa4k+A4o2MzAzWNHNLZXdlcKkzWqOw8dlTjlS7aZUzhLPaYA
         7bvHy7+j2Ao9kSMfSB2lo9QzkytfhQ2HvKay9bVC316WBhj8WxsndNTNdQ82t9pb+rU/
         PVika6cFgczF9x7aliSYMlZkQWZukxKgF/pl9PHot90b3YCi2OmgXaGitwwEHlZBAlq8
         v+wQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795744929; x=1796349729; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CD6edFGqmU8n4mTR3UtP0gostgp/pYDUUVhaESpICv4=;
        b=c0rclIWEcEIJ+2EjF4VTRFWXap20AxoJDC3Bj87A/9bUKzz64T+mbBRUyLylFsayXQ
         iRCT7+fKNdLNVaM1XxMCZmwi2SxBcOEC5Q/d4SDuGoPO2yOXjvwUXOQJA7YhrTHilZs7
         W+CzBGLKD8ilNkm7DeYaAFgNwmoltwmNYD9CvESS63DM7oMnU9BYmclrAXjJ/sMFwQow
         lI7PTA2JPML6x9zEu/ZuuIfrsno3tYpO/wY4d8zHl0Lm6BVi0oloQhfzZ4Komef9V6CD
         dgU/9UDIUFyC2VSs4qhCJhuT5oVL9upRdGio9mdLf5v81WYBBp64LK743ZZqZc4wjAUn
         PQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795744929; x=1796349729;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CD6edFGqmU8n4mTR3UtP0gostgp/pYDUUVhaESpICv4=;
        b=SxiWMoyUhovWbSG5Fg9S2T+tibWL0qKZX6ac6qAXqxIT0zQKktT1WrjHwwGkHqWe3O
         e324fcvGLbM2fn+PEaWCUUUV+3Wy8nBrjiEcOJeGIyUTB6xrUrdjIhFlfjdazFne/FQX
         RhyPshZpBC2wCtNYOfRH1sScjzk30tgPkAwOucNwS5KYKNJ9j1prf64AYsu4XzWhSlWf
         8gNVfVri1TN1rW1obITUdKGTsIyQCrRd+wISvvhxUBxqyMhdgMhV31ndf60ImZQVOhtq
         0QccUWrg1RpnQQCX/Jwv+AK+P4kJ+avfUWlZoacp5eR1/IVOh3aA8oOtop1ddrPrXz5M
         ksvQ==
X-Forwarded-Encrypted: i=1; AL+hErEASVZ8mo6kHsr6A1XxEQrOhRRebM936mY1halm1wexWA+4F/rdvlHYlvc4TQW0UAESTYoCkRzreQ==@kvack.org
X-Gm-Message-State: APuU4Z/A9XtqxKxY6cGeSKvRFrYWvS3h7EIE39EF04xyBIBUIHG/dqHM
	a0zHL5o3loRu6jhJ64DfrI1EBHUCx00dYjxR3W66lSEJ7HcQT6jqI2A5jQsi5zkXVBHSzyNh8Ls
	SVJwrf4tklgrpZ0i8SblHagOP1N1jTDU=
X-Gm-Gg: AZFdTZe9nIH+kDjjLjeL2IoRjXh54Zz0lOOBAEyeLe95NgqP8ILkLwNPIn6Mj3mtpBr
	FQBW22HaM8sX8OZi7FmHZ1rYmhQsUUBb2fODKtHmaTWY5nGYN9sz/69NYOeIy8jDbGCf3ikhQeR
	ygBBDGaZ5bqdVzaQ/fTbgGdKga524adoIGw/iEMCx+aubJD5hIrkaPOhiqbctzA6Fzl/RE/lRE5
	Xwx8/ru2A5McZ7IXJ3TrnaJL17W16z6Q0L49DiuBhQSgxfM1z4o05r/1TZE3zaRAAqOGrAHFfk4
	8a3EB0dMFirP2qkrRRcFt6oqBgmvUZbrGgcbz+M5mOxx2DnpmvjqD9rNAXp8ouz1NWupYwCe/5N
	NGndRu9j+R2AeYeYkDB5JVWlkzj1HBzH/O1tp9bWsAeV7AFpSCwOXEGi9aHZRoaeXipypdg==
X-Received: by 2002:a17:906:ad1:b0:c2d:d408:5d9c with SMTP id
 a640c23a62f3a-c513ac9c0d9mr1294611566b.48.1795744929390; Thu, 26 Nov 2026
 18:02:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com> <e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org>
 <awa30hwg6x82REoo@KASONG-MC4> <8ec3f3e2-5d3a-4bed-a571-88f7ba473b00@linux.dev>
In-Reply-To: <8ec3f3e2-5d3a-4bed-a571-88f7ba473b00@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 27 Nov 2026 10:01:32 +0800
X-Gm-Features: Aa3M54rPWlNF1ipPnICVor68aKhcFmTtxDUbh6IGLENPtyVP2_2XjRG7xOmJZ1o
Message-ID: <CAMgjq7Ayu9H85wurRAUdmXEPWYi9BdLJW13BhK+LMYoBX_7fuw@mail.gmail.com>
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
To: Ridong Chen <ridong.chen@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: 130D82000A
X-Stat-Signature: 5xzjkbtac6opdsijk5s5qn6rch5ur6ff
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795744930-383313
X-HE-Meta: U2FsdGVkX1+lT9IBPHNCyeElwo9JzzoA6Tq6hHj351gb0mTzTAZ8ACmAI5zX1uZ2wHYiNAPcv/KKDU64cFLGtdJJIfWeb4DleKZ2gNpGmgwyTTmaFnwPP0JX1huZvCUhDExIqjgD6GQ/6+wzpLX+MRKIv+AIAtGenxrtVOtSjv1KfukymyE3cN8tGzsSdUU+ngpkKA/WhX9YTXpkPUnWaKOSqz7IsHJIDvn8fy9GOagArv1dm0o60xSfVY7H/jMxmORV5Ph+4dWeDCR6qxxUeYl6t1VPxQGuf1/R7giHKg48ooI6VTQAGhe0C82qKdBj9NNR/ONO1U+IvEe1SBFstVUhF7+MaXaQ78N3ojf8X6cdvV/mtW2OOx2y0TwPNn4XmRj/LOaU+05nKeDByyIR4xsYsCHM6PH1wDg9KZcBp3+qCZPQtPC73Gp1NBgnVEYn06bA7E0d0KXz/Ku2OhF3Q6mAeOHjmMIze0EPpOpRXV+BQCJO7oinYUU7SCCELaSW0dz/CkRvSTJG67hXFBZ/nLVRgaKH9Bg5CE6d49C7GNZv9xqPd/evZDqq/cQ6djOfYP7jNgrkEbY+rHTyIcQTNlFKlUwOJqf7sVhfERfVNQnMAZ55UnzipgDFegO71CgyYcfpDAGDWz8J6gJmRhy4neCxEUrDrFV2BNuTem6Z7R2QCC/HI6/OcF6tDuDEn6szBzoxnXcpDIOy0OTz1lwvbe4DCzjAGWhnSalk3R7HGMFNTSVQLqDSORs/4ni5yKpm4jHTdYy0igkHd755syPiPINo/qzVE/XARB+Zjuo6dqpeyAr7FzBd6ePyCS4xBgcEQcopQZCC0CzSJej1e+4UFEx/1AwFZNev777a+Phm8Q/R+cxw0l+wWdRvZS6IyesBVnm5b2gmBFT8X/fmz/Qc5oLmpLfsOQmBQilmQVp1dsOr1BczMQWIOh7vu/2DebRqjiYXRG+ggx8716f/BbH
 18uf66iX
 ryYtfcmp5HRxzvsmNtbQGkVgS4tafp3/gBjJMYA0fjh2PXZsubsW6LQGbTw1jsCZzaea17CiRnBMY/ig9r5dNkmnjygOAs0VhwSxOQxr8brrHgSsRK8qupvCGt/WiZjQVBBK7tpZItq0G0pEr2wUqrrghaEFa2Gli6rbuvO4GI0ntVv/yRgLXiqGJzebGATNQ/bjrgoBr81ogaOMrIYxr5PAIVHDPUKKrcpToGzIqC6gyewqZyi6SRbtprPryD58uHJ29Oas06fWOd9TBqOn51KmKQG/14kjJbmJX7ZmpKJRvwSQFRF1gv+so3BVmJfLmGAFeOBFT9aedvpiKVtGPQVk0LXJ9vmfnk9+sBoP30NF1ARkZanoTBbyIXtBLGnBB42waWVfF37zAMCTInFYrGdoWqtsGJmebQwjjYT+6RNimWH1DWZXe7EsxaEBs6ERxloA0d9pSsBtHu0YGnqhH7KHKYx1fTvJ5vNcRL7DpRK3OK74/aXKqAWT0lkk3P5cprIvtvvt6gsfXPlpS69eRLNIfK3BkBT3s+sJ7QwETCuKnmsKOE01yYoxJsilLHMOviX2YVzURmcy/jjt/wupQNDjp06TIeoHt0qCxLY9CWsKui4KSW7SxUe40+8gG5pLQYitsmqLjJtMWnkcLfnqeOgG1/tHizdxwQaJNwU7YTPLq9nfODuLq8aGQZvwmgtUOsPsAQd8coFWxVcMLzsBBs7JgdEh58L28A8k6XiwJIjgwxbG6FPkBp1bfyVtEXsPy2Odf2d6nmIGtTDOyd7BTcrCKc1oTMI7G0PW/+TcGvKY1hk2bqqkhEPf94tbuzfRxJrGvGQGB0/G3cp73x2Ch6by54iG22tbRIK3Tc7zFf45Qhfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 9:48=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 11/25/2026 8:36 PM, Kairui Song wrote:
> >> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> >>> From: Kairui Song<kasong@tencent.com>
> >>>
> >>> Pure code shuffle, no behavior change.
> >>>
> >>> Make the folio LRU refs helpers available regardless of CONFIG_LRU_GE=
N.
> >>> Without MGLRU the extra bits are never set, so they are inert. Move t=
he
> >>> lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
> >>> unifying the API for checking folio referenced and workingset status.
> >>>
> >>> folio_migrate_lru_refs() now migrates the complete refs count,
> >>> including PG_workingset (bit 1 of the encoding), bitwise identical to
> >>> the direct copy dropped from folio_migrate_flags().
> >>>
> >>> lru_set_refs_flags() skips the nonexistent mask bits when
> >>> LRU_REFS_WIDTH collapses to 0, preserving the two independent flags f=
or
> >>> !CONFIG_LRU_GEN builds.
> >>>
> >>> Tested-by: Zhao Zhenzhuo<zhaozhengzhuo@uniontech.com>
> >>> Reviewed-by: Kunwu Chan<kunwu.chan@gmail.com>
> >>> Tested-by: Andrew Morton<akpm@linux-foundation.org>
> >>> Signed-off-by: Kairui Song<kasong@tencent.com>
> >>> ---
> >>>   include/linux/mm_inline.h | 55 ++++++++++++++++++++++++------------=
-----------
> >> I'm starting to feel like all of these mglru/reclaim thingies should g=
o into a
> >> dedicated helper.
> > Hi David
> >
> > I saw your comment on other patches too, about the header mm_inline.h,
> > about ~690 / 860 lines of code in it is for MGLRU / CLRU only. The
> > rest ~200 are for VMA / TLB / MMU.
> >
> >> Can you do that as a prio cleanup in this series, so we don't have to =
mess with
> >> mm_inline.h in later patches anymore?
> > Perhaps we can instead move the non LRU helpers in it?
> > These helpers:
> >
> >    - anon_vma_name_get
> >    - anon_vma_name_put
> >    - anon_vma_name_reuse
> >    - dup_anon_vma_name
> >    - free_anon_vma_name
> >    - anon_vma_name_eq
> >    - pfnmap_track_ctx_release
> >    - init_tlb_flush_pending
> >    - inc_tlb_flush_pending
> >    - dec_tlb_flush_pending
> >    - mm_tlb_flush_pending
> >    - mm_tlb_flush_nested
> >    - copy_pte_marker
> >    - num_pages_contiguous
> >
> > All other helper in mm_inline.h are for LRU. So we rename mm_inline.h
> > to mm_lru.h?
>
> Moving the VMA/TLB helpers out looks good to me as a first step.
>
> For the LRU part, there is already mm/vmscan.h, added by "mm/vmscan:
> move struct scan_control to a dedicated header" in mm-new. Most LRU
> helpers are only used inside mm/, e.g. lruvec_add_folio(),
> lruvec_add_folio_tail(), lru_gen_add_folio() and the refs encoding
> helpers, so they could move there instead of staying in a public
> header. Barry also suggested moving lruvec_add_folio() and friends
> to mm/vmscan.h in another thread.
>
> A few are used outside mm/ and need to stay public:
> folio_lru_list() in include/trace/events/pagemap.h, and
> folio_test_workingset() in fs/btrfs and fs/erofs after patch 16. So
> maybe keep a small public header for those, and move the rest to
> mm/vmscan.h, or to a separate mm/mglru.h if it gets too large, as
> David mentioned.
>
> I can help with the mm/vmscan.h part if that works for you.

Good idea! Maybe you can send a series to do that which I'll rebase on
top of. Feel free to take the first renaming patch too since they
should all be zero-feature-change :-D

But please help keep some helpers in a public helper so when we are
able to get rid of folio_*_referenced and folio_*_workingset, there
wron't be some strange header inclusion issues. FS users quite often
need to call them, especially the folio refs related ones.

Meanwhile I hope we won't take too long to get FG merged because users
with swappiness 200 could experience serious regressions with the
recent swappiness change, and there are already several long standing
/ recent regression that are waiting to be solved by FG :/

(Considering MGLRU even used to try to completely ignore anon reclaim
at swappiness 200 about a year ago, maybe that isn't too much of a
problem, but it's still a problem).

