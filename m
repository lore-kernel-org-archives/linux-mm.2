Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AC0BC55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 14:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E800A6B007B; Sat,  1 Aug 2026 10:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31CE6B0088; Sat,  1 Aug 2026 10:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FE36B008A; Sat,  1 Aug 2026 10:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDEE6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 10:00:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDD2D402FA
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:00:51 +0000 (UTC)
X-FDA: 85052861502.01.ED67625
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 18EAA2000D
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:00:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b="sqTRUZ/i";
	spf=pass (imf13.hostedemail.com: domain of luto@amacapital.net designates 209.85.208.178 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785592850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZRJkSRYLvhWoKW5wE2ChSY4jyv1xejt7euQKuPJZ4+Y=;
	b=8M58UJaJv77tNY9g4YLGZZYIQGjV7t8cmwxGUiiLf4PYkgwyOWuMxp9UGW/DP5iUG1WiZA
	KcyYczO70PcvPHj10lVN0x6jiG3G/4N2rPuzVOyelr7xgkqUmh9uvjoCLj1t6i1lAgwuQV
	rknsxvqByLMvu1W+KFAqw4JmoBzJ2O0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785592850;
	b=OryXWLPCHttN6Jaldc8S/kkoy5FrDRx/i6KvT63T86s90XNeAIcITnnyn1lsTNIHZc17aq
	0J3Q6a9WoGLcvh0geezc6feSoMQuBnol4V2cA6loIJl985UB7x1Kwlz5F81WIHLUMSDjvN
	XCDbvbNtPNqNkXbIg/7AsD58PiiSu48=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b="sqTRUZ/i";
	spf=pass (imf13.hostedemail.com: domain of luto@amacapital.net designates 209.85.208.178 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-39c7fd45465so16750951fa.1
        for <linux-mm@kvack.org>; Sat, 01 Aug 2026 07:00:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785592848; cv=none;
        d=google.com; s=arc-20260327;
        b=TjfgazHDwGFbVrP+osXuIq8ds5XHgnW1fKc3lkh/VWVRJnWmOUFa5pQV9Bhd/Di3iw
         2pmXNvIoO4FDZum9oBEHWTednkz7TT80oKSZXvtPRwYTvbOvy9kqmZd4ZxrrbVnprFjC
         oeokzfq+zqoYydWXrf5Lt2LTNAQCwp07BGlAjkr+00lFp1CRjOMEjUcuOwKP/k2ukXwV
         zsZ2oKnCSuEhIitxZgnSUkEMDSv3x8TrhP1OnlXTpOIjagYMYQ5ScCac9QwUpRJ1WJPP
         qzD4ZNNdEP7EdaCzc7FGfYuV3V0yCzs3qC6RjuTd4Cdde0UbkN88sG1ZxH4Nf42mGKgY
         1Evw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ZRJkSRYLvhWoKW5wE2ChSY4jyv1xejt7euQKuPJZ4+Y=;
        fh=CIuLf+UTB57xam21wo9SOWCHp974tTxtZfQZo9olesc=;
        b=J/MGtWeZkMt50eD3xHgK5qySa72ViRqnN47I053dV+szFhN4zK0OVHdZj3wlllYeJ7
         YqmdOuUMztKYgnrHnDGScucwwhzDskOaKV4tTsqk56GSr5PgYzZK32didslnzBBRYq5p
         xhZQTgTfy2TRYdx4urOo2tVpV7TtESwEcde9E4dLvm9/jbVWRx61xcv+I09eGLdZatIe
         5B9RN8ztvHQVsxEr8RrYYvgjgabzvCWc5hbKJcnJ/E1NTJLylwan2GyF4FigIPEtD6Hn
         g92lxXdhHXFVWZeTR1HobycbNd98GZcGOTj+iajPyhJOo1/MBIfXZzk+y1jfsKMewR43
         jY0g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1785592848; x=1786197648; darn=kvack.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZRJkSRYLvhWoKW5wE2ChSY4jyv1xejt7euQKuPJZ4+Y=;
        b=sqTRUZ/i7kxh2ruORdAOXOprC0zWIUAcLo79Bw69CKug/7eCyfl4xbTysRnZmrvmdz
         0TJGIFwWf/wIhNTaCNk8GDrzQEr+8lE5vlAno/hZ/zPXr7JOWyhNNKL0uvXH8guAMwWz
         ottmom3uypcpVuJY+w3RlypE/4soNAGBVicV2Acgg5NFRuBT82Bu+dwIKJ7FSEmfTqte
         E/A4RLIoqLfoe3ZausV0q626o8satvKd5LOA5cshphDbhfaE2GGF2VCm8uxzijnCzmTj
         XawIMlt4jhdV4h7vkZJxnhv7PKenbSyzf2WBKLRJO81J+qIEDTq3b+JgbT2J8f+iVXyu
         dfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785592848; x=1786197648;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZRJkSRYLvhWoKW5wE2ChSY4jyv1xejt7euQKuPJZ4+Y=;
        b=r1xe2dseNx2IaSiX1GTdfLhZI+0KIBiEtT+25trnQRzwq69R0vipoWbhgKIxOPa/+d
         wTBaaUzZjfZ7AFiWuAMrm+oZEL7KAor5cfdRmtDm7rxRAPfqvhmdkSgG1dBsoaDCXi8z
         a8VpmwTboVwPM7IMxLwytqtxBr3tWKOiJLmuY6gs4BOejsWqHqvt4C5tWj+At6q5XTw4
         ouOWqZYlJGACxx08sg5fhrSSXGge2MN75OkyjrQvIEpmL121n+FCLIQvHIyAcpNKlKj5
         5GcnRzUd2EevwwZgX2WGPh6g8vAduUBUbJQmhzKgqkqKjYIdA92BdLz2DVV3E1NRlFy1
         4yyw==
X-Forwarded-Encrypted: i=1; AHgh+Rqf7mI4jrpAwhAHJRICT1mpZDc/M9MYjhsvxPrvSUAvPP7K8VvDYkplpJ4Hbi7ku9tswydD4Kejng==@kvack.org
X-Gm-Message-State: AOJu0Yw3aa+Ay2wby6veHZS387ZVsW4ifDkhHl41Rwts4b+H804AfENw
	qIVdxOv7KAC0m1OYIhwKiaOkT9N2ytPgebZeNSPPnGdSD9/sCsZJFr9cIXVjfiLOJs31LHUFg5m
	d6dLki02BumDwUW/ffVDl/3ntAYnOzoq+dbmPDLgc
X-Gm-Gg: AR+sD119g4o6eQKIgLDcBGuDYui7GUsIVbvSlsQ0pUrMavWzsyGUiKKAP/4dZ4j4PwN
	I5ZLt8zpO+T2vif3VCNbfng/hry6Ejg1CJBoiMgO1zlw2W+1Dz/8jzcaZul1oFv3rEIiBxSTTC0
	iuodWTJSWVgRMdwbuLgaRSVqCEcrQwauyd410SK2RTsz26JUJPvsI14bqtOPzLVg/uCCtDTxazH
	mku2N8QduasTu9HYydGoATWB69bNCuRUDVKOlfkIWbXzm1JDcywaRgvnCWJDt/WmAlBdy/4pxoT
	lKsfPyd7IzFD1lJzEOYCdvKL34zl7cIzjGbHMuqyXg==
X-Received: by 2002:a2e:bd02:0:b0:399:767d:c118 with SMTP id
 38308e7fff4ca-39f862d6c73mr6559161fa.23.1785592848320; Sat, 01 Aug 2026
 07:00:48 -0700 (PDT)
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 1 Aug 2026 07:00:36 -0700
X-Gm-Features: AUfX_mweTyYVCxpa9foQ144vqzcL8WzG2Quj3VmGrGcQ9-NGP9rO1jbWFu1aHLM
Message-ID: <CALCETrXbj__SFQMzPZhES5y6-sh4np-ZHY5T_=4QY5+Fn8BM4A@mail.gmail.com>
Subject: TLB free bug in 4c640eb4181c ("mm: move pte table reclaim code to memory.c")
To: David Hildenbrand <david@kernel.org>, zhengqi.arch@bytedance.com, 
	"Liam R . Howlett" <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18EAA2000D
X-Stat-Signature: gnybeqfwuhpu4duhcojccox9xzaa6oxw
X-HE-Tag: 1785592849-384432
X-HE-Meta: U2FsdGVkX18j2Qn67z5GFgRQuurhugUokvkUfO2K2n6eA3b1SyAHK12GMtS4oya6RqLPZZzqT6YzulcZqj6jJHdENXEnjwFCEJx0wcjlIIlRwJXH48VX3YmCahq3ukgMFeyzEmrh0fEk40yKEXhCyM+7L3Yj2XmyoZ7Hw6A6gvWOAY3d6Bz8q5TmOOqHUZqb9d/KuyhtCPQg8Jeb3R2lMAgan3FFbPjr5Nxq1thvLWk5PcF178IJOBIvvFqm2Ghrsy4Zhl97DbuMYch6hfbYio8Iet+dTREfW7fQRbwjekZCRwJD/+fmm1bFixQQLg0sWeaP9/xAqbshB9NV2r4krYalMu6QzK7Pg9a5gCpPeXwsfLO4UmDefKkEcgYlU2gjogOd/rX08adkkrQetbVoWV6wJhUyHZ09bOBD9ZwRbf9sfJeoQx2D5UZXKPZOX5BqpDh0RRTMpjI5L2SbRzSsS52jvQop7HLd4KkAxYqXzx/dVq2CpZRpzJEX3WKUuBKxR+J9wvF7vPpMU22EUObvBG7znJFkxb7ZSNT00eOusprRybGMm+HIorwT1Yu3QYLZmID2N5B0XN9bNiCEVxKmcrRFQoAN4YBb4Epd0TM52M+Zi/KZko4/M8ZeybKjzyJ7NMG4qboRbU/PZV54PuBEnqg7yF9c/TPeqZ4WHUy3bx8xr8/pScKv+W3eaAENIA0TO2LHCIUiN+7ZHSw8J3kQy6J48fVvGb5WBRxxLwDofVy4U3dAAA+2UAuC/bA/n8Eyjo4TTbOFD4RoJjZ+5cQZPm6LzrwL1yKi21qjVg1PFPxIP8uMf+d2mNS/1N4zpu5sfND43rdWnZSHJy6KUx6H9MIeRlg8VlJOPOASEaCXbOAar6c075v4Ic2IORR/+Z6mDU65cR+aUlHl7ODZnZAo0bfeBl6cF+1rqFeVuZkSf69pr34LR5WcBE5AoJwkaiO9EOqQNfJWoCuFvoG2lB8
 aLy+rnCn
 NMn7JH2RcR7FGAj11h8rV0YQud8nSj5sKG4senOv1o16IDD5XiiiFDBWhL0UYzCIcmPQHCPGnsARP0N2bK7Ip60hhlqSZ2mkc9X6D8/krqJatnLc+YtwKw78BVOYLLMXyR4eNHbb1eOO5CJN0nmEzTx4CvIpFAjQ7b1rmc5sRFX8a5WFjjBfVRGbxP/v7iAjUcZgb9w5hFuFDN+ILHYRWQxAHHU23rxh/Lik0OmcboCLkMBRSk355lDJdJP/LtYbjfHrJMlnO2NWBtS/APHscU/4C/5oqHR8q9K+UoPge/pnBPAl5zZRbxlQueVbXwqPtUgHBcAM+eRdgtXb70hn7sNzmH1j7iHGRZtDw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all-

I saw a fun bug report in ripgrep and a studious but pretty bad
AI-generated analysis, and I peeked at the actual code.  I'm rather
suspicious of this:

    if (can_reclaim_pt) {
        if (direct_reclaim || zap_pte_table_if_empty(mm, pmd, start, &pmdval)) {
            pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);  <-- what is
addr here?
            mm_dec_nr_ptes(mm);
        }
    }

It looks to me (and an LLM -- I can *never* remember what all the
tlb_xyz functions do, so I asked an LLM for a summary), like addr is
not guaranteed to point at the range being zapped, because the do loop
above may increment it right past the end.

On x86, by my reading of the extremely vague text in the SDM volume 3,
INVLPG doesn't care in the sense that (most of?) the code paths
reaching this have already validated that there weren't any live PTEs
in the page and INVLPG promises to flush higher level paging structure
caches for *all* addresses.  But INVPCID makes no such promise that I
can see.

So it kind of seems like this code might end up flushing the wrong
paging structure caches, leaving all *actual mappings* in the TLB
valid but also leaving a cached reference to the to-be-freed
pagetable.  Which would be quite bad.

Original report here:

https://github.com/BurntSushi/ripgrep/issues/3494

I haven't sent a patch because I *still* don't pretend to have
followed what all the tlb_ functions promise to do, and I don't want
to submit a subtle patch based just on an LLM telling me what *it*
thinks those functions do.  I could trace though all this mess
manually, but I bet that one of you actually remembers :)

--Andy

