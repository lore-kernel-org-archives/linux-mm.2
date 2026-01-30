Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 393A8E6BF17
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 14:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF3C6B0089; Fri, 30 Jan 2026 09:16:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD1A6B008A; Fri, 30 Jan 2026 09:16:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4456B008C; Fri, 30 Jan 2026 09:16:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7FC6B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:16:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B5951A0371
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:16:52 +0000 (UTC)
X-FDA: 84388831464.29.B408218
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1B7EF140004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:16:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NH5/dw6b";
	spf=pass (imf09.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769782610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mi9NfLL6XsvEcvPix84+2CGe08mEADYsw4CLeicT960=;
	b=S/epZcn52E6bTumaa67InKrmnqrXoRfBB1U8QbSC2hORHc9hghxymGR7lyDVujCu1xEb/S
	ahvf10xKffit9lxMw964NEUurDT53SwMsDvd8Wm5uhxhTvrUG6o1Nql5QY7xtvsR65kntu
	lP9S+4/zLztl8mMP+R4zGKNKHD1VKmg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NH5/dw6b";
	spf=pass (imf09.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769782610; a=rsa-sha256;
	cv=pass;
	b=KwQzNDYyUxeNddg7WPgKOpmOYmJVL93fXBj4xad6WF5jB5Eij1pfCZEuHyCQVOrqcXZ1M4
	w5GX+aiC3R+onoIvM33T2D6r0hDAQwoT6VDu6fa+3OQo7EctGz5aWlNBLe4QmD/H5ur0mw
	jsInPshZsNnlW2NiiAEPIzFAwwr+iok=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7cfd65ea639so1358331a34.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:16:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769782609; cv=none;
        d=google.com; s=arc-20240605;
        b=Np0AuZaXH9H9Znrxvw/byY+Wax29IvXqpXAqiK0kRcIbU9p842d4dIZLF1aDmhL1LT
         ulW8zHyHlnU+1/+7gw3Q6YC/d2TAUoaP6U6x13rhmZthn7ZB1vH8qh/rYrHnDTXAtKlS
         OxXmz0cM08BkAvIpiaKeIVZZ7nWNV4MDJDC9vgW+f3ltXMIw5QKAhPwiqfhASi7mDsn3
         T34wuVQ9vP7/qMugWJt0Y7V4lSMeyBPCsxxea5Crk4rics70U6UVfy10kL4Gcg9zfoUn
         lojRCDYB7Kg0UaAuJICj5R9wpoddAG46QuiXZD2rjKAGlrLirOEc1duopPhBpIO7iSXl
         /gZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Mi9NfLL6XsvEcvPix84+2CGe08mEADYsw4CLeicT960=;
        fh=GpN2k/+uo7XStOSyHwBbqZDZfJ09iiNSJedjbWavZho=;
        b=YhhNJUMenpdJrN4ujyWxDFZcQksfsD4zyKoegDnlN0rw6NDfUrgiFUzFkvp+FrfA90
         Ga1XFhXzZdgbJeWXaJ4WeopNGvNRX6l/oBAjN+QtJt4mOEELkjP9JAy39OYwp09GgFda
         Qhj/P1V2s9BAQ/N1UOTUq48ihc7PnRKpbRLAKZAO0uYOBG+HGonGXzY3aRZ7aVw50WwB
         Lt+2+S2We5lVXaE5lDRhyY4Qihnff/IiFNbm1f7VeuqENG08IE6crLcwgfcpBF8/7JbA
         /i27v8fXi/3yvnAHvjB+Dh2F6Kge8S2pU1IwrT1uURSKuQqa+t6kiSW6gP8rjtxvpPRg
         uOUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769782609; x=1770387409; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mi9NfLL6XsvEcvPix84+2CGe08mEADYsw4CLeicT960=;
        b=NH5/dw6bXvt+vBASlyWccRSbqCEmDkOL2vzctDYGJbfeZrBffALu1k7CDNg87Ym8fE
         14F4H93jzXNz6wrgpmTSPr6s1cl+rQJdaqT4RNqjUVw2YbwVVm8XCR7/OiBPQN0sWNZo
         z/qQ1KqaxqhDrXZGqAZagDHj5GA2dLFhzaPVXHCapP8HIvpkZE2ccLEKF3IQkPakwaZf
         98yCrG/0KyxteXrCJKwm9r0855DWwx3zX4NGCunrjLmJgU6Roz4LqqCk0GJMSylFdqTW
         urKK5TZ5aFGVhyladGcseg5hwyfVvl2JkNgmmcsMg8IS0Cq4mU7XXCN/chP5aUWNSDW9
         ItIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769782609; x=1770387409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mi9NfLL6XsvEcvPix84+2CGe08mEADYsw4CLeicT960=;
        b=tvlIg1LBqDMTcnHdEncZsdhbFRiQYsyO65l8ZKAJoahpKJyZL3hGBaIiVGkwKuN2gk
         cR6i+fOjuhof6XtN1k4N2VFjr3RikV0OJjYaZtkZbNcQ65jVJVQEOd4P7Ifz1RKy2C1/
         I4OAdUTAan+6eVuPItkneVFVldsTjiq9iX78ndt5j4Rf7eQBfDsSBDUnu3r5Zug96MJu
         5cvaEPVkY7HPITG79mRPuQv3z2sQOtQmrXATjcNNzBZenvoYLI+0URsy3Zx5e41Yl+kp
         dzk1N8PuanghQP+piXeFW4TsxK54PBFoR25wQxEgSgkT+g7eJFEbJFebbJW6/AqFBF4S
         Ixnw==
X-Gm-Message-State: AOJu0Yz52Jao4lBeotXfEU5Zr+J+gsy/iecWJpPQ1mWoxOF3Kd1jAS/4
	S4H6M+DAnDLyEA8iUV1/gFNkTcvqxrkfbBvT9lVxCqdyFPLLyDzHgwfO6kREVkcL/9wYyucSg/7
	uL4PKl9K8N69W0weU4E63Nu0vqAbzLMY=
X-Gm-Gg: AZuq6aL5+8OZO+KruZIardm7gvI8nvn67DRhXExfd3hFJxYtEe5txyo1tH0BvFHPmwk
	IS5/puS5Knq2c2/+r+h1JuONgm3eEfhnhdzQdGBzlL0n5YK45cwLkVoxgw9M9rB6XRbb5Yf+Huk
	4krkTutBukhTMuNmp5a6h9D8T8eLh7ieMXVj24JOYg/3ao/dkx0oZpTa/Ub4pH7d3i1Lz+4OaC/
	Ml7yqOH6VXuKSqRKtuC3ZvIxDautu2tcaZjGlRoxKGl/KsFuOPwRdZkFUNo52tN0qdII93A1Q==
X-Received: by 2002:a05:6830:448c:b0:7cf:d784:5ca with SMTP id
 46e09a7af769-7d1a534e8e7mr1827945a34.19.1769782608869; Fri, 30 Jan 2026
 06:16:48 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
 <aXy5U7XJSoSG5HpE@casper.infradead.org>
In-Reply-To: <aXy5U7XJSoSG5HpE@casper.infradead.org>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Fri, 30 Jan 2026 19:16:37 +0500
X-Gm-Features: AZwV_Qhou7Z-vVXOvMPl4-YZ8CF0DqUz_xTVLxsEJwd8WLPDA8VgWUJnKKfWLuM
Message-ID: <CABXGCsOXn834-kWPJtwJiX2fMw_oDBkhMR9xVi3Yqu6ez58k+g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: fix use-after-free in swap due to
 stale page data after split_page()
To: Matthew Wilcox <willy@infradead.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>, 
	Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, chrisl@kernel.org, kasong@tencent.com, 
	Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: e35zr8tnezh3kjn8yqsoicexm4nq8gx3
X-Rspamd-Queue-Id: 1B7EF140004
X-Rspam-User: 
X-HE-Tag: 1769782609-435913
X-HE-Meta: U2FsdGVkX1+LEd6RbRcABdWJN+0bLfIRTfptWdMiHG6yVmgDqT45XMq79P4tJXPn5ci9R+sRAMTu2V6a+As9LoH3PwnCaPmUu/A9878U6mf1t3v0DsVk/AAkY0xErHGauHUivJCNd8eoE+82+ttRi/d0ZFZB2t+Yr18sTcnZRfFFBv81TKEzrHGGYWRoLVLZDTjFbE+KO8JwY8gk6ZrbUBN5EfBeIexYOOjZUoqYr9qcGgjO6BD/imTdaiXMzAlbJ3gy5DXizLePPh8JVqmCMjo6Urf8reEKq3raUjGJxYcuaQfrl0A7THx/ABntOgf8WFIRCeiMVXM+nHlTbJlR0PkHjz/mFQDHv44V8QiRyR+un/n9QqsGKe9s8eoyVAJxM1d/Fr1LqyTDuIzbbvoALYPVt+WDG4opVVN0iQ/E9vzuLkZYiVvnSGRmrMVH6z7uefSou1RQeo435DkrnBg/VwyfLJog7GhChWps+EHmeVT26HVoduQhrMIHGDQ0IdiTEIB6V1zjph8W57Bmd0zObafRgELl2Q8zo4xgZd3fjwJl0qRCeXMC962CBYihBLvCCt53q39jz4bLJOPQd+JDBQ4Z2Vm+HC41Qlaqb9zSmQQalIhJpSnwWOujVHluJi1iyWCduLLFvlMEt8Z8RZcufm3NP0G+4EpNb7Lorczx68VoP5OalLRh8w8SRgkxvyCKaZzx10VBA8Fa7nslKI+BZz4jZnZTduRfGAc+d87g/ETitCUocnEIjpFrna/DPd3ijYaLVYu2KUjKjZTiItHZiVQ4EpgZC5kJ/86xEInzrkpzFXDPEThpxHa4DaZS/OG1bb2yvg2iu33XLVFVMmzf27irFVGW6IPPKkj/u/7CTWxyIoxFVp3cDWxhc8m6rko5CWoc+fkxdKFaNpCPmlLfM+U3li4o0QvXg/vFX30czt6EiPkiCCwNfyRHPTzpbB5cQIQc7o9OHiH45x68+Ys
 ZXNQqJFA
 JGOp2ChNV4xdCUzYl26p8cNLffYGKaeGwJ19XUm+GF3PcLHKMqkRV1/bsyu1XNCNymPaJgYUp1MWs/o1Q4gfB6SGspJXYwBO9N89MAxonBCLO3do5WwilCH0ccakxHIBNIcrUd2wfBqGGm5isI4AegVg9qt3ttAdU/aOo8861qlB+yD93hGNe1Stgh2ilKrW6yWc3Nlx7/saJIf86KDRCmiaZKzP7X8ub9rtD6Hdz0Rd1QDmWomnFPx0MIksaKgkVF7EgFUQRPgKrnMKH/rAtTWhelEg6yHqJ5wX/CUiPt+EtIZfeU9OHy/SVnenhkZNrF/lxD7DZJkX6EoocFHLVsD3qXSs6wCA+Bo+tXo+ETBAREXxnTZmBeuCRnkyYZNQyXyQ2uexcAd5p/5egz5xba4NbwhqdyXwqb5OrpcnkehBjKYPi1xuKnUFwb9ZQA6HvzFxo6XGPEzCH6HgdpChe17iff8f1oA94wRsBW8GkkJ/vGxk483bs1tZcHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 6:59=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> Why add a second loop instead of using the existing one?

You're right, no good reason for a separate loop.
Here's v2:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cbf758e27aa2..306493d76ea4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3122,8 +3122,17 @@ void split_page(struct page *page, unsigned int orde=
r)
        VM_BUG_ON_PAGE(PageCompound(page), page);
        VM_BUG_ON_PAGE(!page_count(page), page);

-       for (i =3D 1; i < (1 << order); i++)
+       /*
+        * Split pages may contain stale data from previous use. Initialize
+        * page->private and page->lru which may have LIST_POISON values.
+        */
+       INIT_LIST_HEAD(&page->lru);
+       for (i =3D 1; i < (1 << order); i++) {
                set_page_refcounted(page + i);
+               set_page_private(page + i, 0);
+               INIT_LIST_HEAD(&page[i].lru);
+       }
+
        split_page_owner(page, order, 0);
        pgalloc_tag_split(page_folio(page), order, 0);
        split_page_memcg(page, order);


Should I send a formal v2 patch?

--=20
Best Regards,
Mike Gavrilov.

