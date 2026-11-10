Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D104E60A2607
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vwcuH70m
Received: by kanga.kvack.org (Postfix)
	id 549606B05C4; Tue, 10 Nov 2026 15:41:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521616B05C6; Tue, 10 Nov 2026 15:41:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410056B05C7; Tue, 10 Nov 2026 15:41:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3F66B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:41:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7B2B1A0966
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:41:01 +0000 (UTC)
X-FDA: 85420378722.10.FDEB85E
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id DFA0A20004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:40:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vwcuH70m;
	spf=pass (imf31.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z2r/5TPOj6xlBCwBMvS5lY/uHLFbDokwBpHEPZnfXAg=;
	b=msJlL/rvJm7bNUENSj/gn3Ohz/UinPayhWt8GLgEApXLD8vXDoJxllZYM8MtXA2sN/HIVd
	FoHVyoLmBkS/MEoe79dYGpJKQOHQFqe+5bBMEunH6UogimYD+U5W05pK4fCQr0YH0zTKxU
	+PRdYmnLpxQt9400OqL8q166UY37dqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343260;
	b=1nH7pad9tpLwrRSRRkePLWi490dmnbmIGp9b5kaKYHcrjjNT1FPW4DzEZ9aTzDvYdh5tOI
	ItMgpUKyhbR4QvIeQoE/BUXFSmOJSRaTAsAwClsmDKVDfSo0/5c0DpcOmtuIO2rmeJvuRF
	Pz+0sIPCoMCnFDq6Gcu/9fVN1Gp4Spg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vwcuH70m;
	spf=pass (imf31.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-36e99cf7bb3so3910216eec.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794343259; x=1794948059; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z2r/5TPOj6xlBCwBMvS5lY/uHLFbDokwBpHEPZnfXAg=;
        b=vwcuH70mu2ThNVwQFQnvs5Xd/d6We/4eTIc4qBZaJXrScZNd/WwiZN1Ol7bHWKPClE
         ThcLkJFhQH15L2ZUcprfk7/eUB8+qWtPFyO8nS2IgizCW1LphV/BkRUzzTQokdw8duOO
         Rx8j2rwZW+C256GCO9o16QRvx9Onf2jvQXdI46b/swLxDMMDdHxl4ocNO/MgDZx3SPNG
         HSy1bvoKi1RO+CZHX8ROxW3g3EcFPmVoDE3He2v5s83MTIefVz7JL48nrm+l3zQO20At
         GNSm7xzmt5XQypiNUicvjW/iCd+4lzWmrKISNqGsJIGD1l+MU3GH33OMmMAMKRnDezd+
         eg9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794343259; x=1794948059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z2r/5TPOj6xlBCwBMvS5lY/uHLFbDokwBpHEPZnfXAg=;
        b=UspTXDswWaDJI12UGOt8ZNXph+W6axZ9rJDGJ1y8oRzHVsUaTFcOIbf/Yz6WZS+G7m
         VzZbvlfSn6syciJYItFQMnHbb/L2VCsLGrf14M94p/rcjVPZPeRzPz6Nkdbtpf/kxPAo
         s9es7v332Ep2l01c55UnW+udDowaCbDtcd3jZKRIFTy2mSubonB83gPIQmHJBDFJ8yGi
         CF4n8p9iJD0tlYGQZGSMVlFcnZHuqH4mX+LhHvOrE8wAEtHTPe/w8WeHH2ux2X5GI4lo
         33gvXhSNPeZHChusgmakN8N+7Ah+5P7B/cCYcuvAk/W0OU0bhDi8tyrEeswt2Xyka1Hk
         qBdw==
X-Gm-Message-State: APuU4Z9nm3OVSbNo3OolwHqx1U02E42e3K8JNLyEPOhwx+BNg9xkijLP
	l9QcFlcwyPJHBUgImdxEJd5j4HMlwwJt4YFkVnBS2DmxhO4iTJZ+aiQS
X-Gm-Gg: AYBFou0r0d5XWClM46twRCom04dtedDvLiTP+LAtQKdj+BVUaxPkgXs6y/+EBB4ap9j
	kGtpWjIhZ7a7RsBH0lFfECycmTcMTGDvNHmbFmJWSiImyWuC4SrGd69seM/nOeRam2jXhTJSTjX
	HMiO4l1GI0Gx5LgXa3ZRP3f8dD7WJz8YHI5RJsnXsMZP/CCsiIx+3lBo7lOrzYq3oK/u7KKkub0
	ZI8BVbVhYhUD72QGbApGencYP2WHQr9JAVz229Liof0HUNfsOu4npVqQYrFdGqCI/F3DGmruAi3
	png/auCKRZ1pGM22UkJ9rkzrkW2fChVdAT+86TCdY1+K/+DQHF/9abm5vznIKsE+jWxwNQfjFKF
	fWiU2suZAUNgRJsErb4I6ErY8xh9PD87TUbJB3FeOWs9hx8PrXNXD6++oSaqsCmwEIT0z8VILTC
	LgAY+ea8BeVWHB6HUOxDmPJt0uok5bEnC35MEXEfPNw/IJhwz7zia66jmgKyitqXkNRimYWX3fc
	AlHMwZ64AXv0D16ecUc+p5J/erTqhb6q4RRSUslQTslcI5hBTNduBW1vu+sSOnorniuCsnTt18e
	WkVzQHIY0Ju0HZsVNts3UNylLPQHjjm5V5JCHuPXKfsXrYz2HW3GgQB/fqwGMbFzAQ==
X-Received: by 2002:a05:693c:600a:b0:35d:4e41:d2c2 with SMTP id 5a478bee46e88-37686d3278amr499900eec.33.1794343258427;
        Tue, 10 Nov 2026 12:40:58 -0800 (PST)
Received: from LAPTOP-KD1TH5BD.tail375eb4.ts.net ([47.11.98.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520bfb58dsm17473286eec.18.2026.11.10.12.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 12:40:57 -0800 (PST)
From: Gopal Malaviya <gopalmalaviya53@gmail.com>
To: akpm@linux-foundation.org,
	willy@infradead.org,
	jack@suse.cz
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	fujunjie1@qq.com,
	vishal.moola@gmail.com,
	roman.gushchin@linux.dev,
	tracekotae@gmail.com,
	sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/filemap: restart mmap readahead on sequential faults after many misses
Date: Tue, 10 Nov 2026 20:40:35 +0000
Message-ID: <20261110204035.184968-1-gopalmalaviya53@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-206717@kernel.org>
References: <20261109091444.128521-1-gopalmalaviya53@gmail.com> <sashiko-outbox-206717@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DFA0A20004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: wi4tft998xr93edpuocj9jto978k6o7o
X-Rspam-User: 
X-HE-Tag: 1794343259-970065
X-HE-Meta: U2FsdGVkX18wzEeyODhnstFVzH7dVVfQHOK2/1dh1cpYQLGgGzEgbdvCYsSZiOrec4ArZHAH0ojC+VSFLnss/XsHCz02733AeR0XuSNg0O75VbhEit9jV84qVSA08cKMef9Ot4XyUJvbbxNJagaHjUXpW5T/hcyEy5syf/wLLsoozkL03fzjFYxLn0b2QTf1ZhZ+PswO+sIUroz9Ks1LEKctc8pBb+5goGhR8JpnMgoOuHCJ0uMh+FD4xRpVK5lIcgU8pJosQ34tTsUQUzK1IhFamrXt/KFzYzoIywsxsYo5jeAhbd190dCdmoKgfMRxNiMyidL54kOfdeJv66unXu/4uh0tqZaeUuvyF5Gz0JcZdVpJAJYddVIqKzhYPwkJ0BhNNwbk8wFEqR2Pn7Jeu08/afczUJeewCT3dMxm9P4AcSR0uI2wMG6yLB4Jyh0pwt0+KOhxV74lu3vM7XhT8WwotO4n2hkBciKzrhpD0x3IdviULJpPsa8f++2LPXtVYkqSQ5w+nidg+HIgO/g2p8fHPzWtOI926DfT17wnSixXEIXKGtm1bFvtnZunn9TDfOx//yTR0A6C2BOlHvTFQwQRAFz/P8W31z20CyZa8dFi0s7e2F8nFtCIbOZb0M7+9JvrnILmJfCIHF0LTa7tgVWYSzH/63KeY+77ZZ3nbW1ZBFvXQOoeSqYqM0fjzh/Q8pc/4h4ZcAO6RDqzr0/OHI/Y2ONtIe3CeOQ+N+NRr+moPaXkxFZXq2Zs4ZY9cELAOeZ+DI0OKIZo4ruNoDcYHHVzZBc3ZIWv5/eOpS0oHvOMKS44Uu+utG4BL7IYfIqPSNdeRHX0Cq1XkWPF1F8G/K9G3pYJz6o8k06cF0KFTvksP0PxhGTsLNeiJyFFHlUNG4/seO3Lb7w601u2JdHal8cTAtTZJH+OKvRZlUm4VP91XzdJTdS9Pn37xT50F/MThMHGMkZ9hnWpBGcpyjG
 mh7yCHh/
 DHuMOeXIeX/S6DsVG6TPAzjh/nYarS3VS2dN9br9W+9KhEr3zSL7DuBG8V2hjeAFoUVwDHjviN83wyQWQK2//R8DhRC+fOoE8hLVuBIZzSjpSfXKBChAbySzTZimsjL4NOQsOztd9d/Q4bJo1PAAIZP9FrASJftgkctZtDrdKHox8BOrPGNSe0donvqN0gVZOiQOtQ0FyfnWrokaXEkhyJeTeboO9XNvuDzsINI4r+9TQCnP7R0DZ9ux8Mm1xhs23EhALItiLCA7vuV2N/iFTAywnT//6RdItQv496RsTzO7K02Ki9YDAAaftElIrgq3QJFOdDywIwL5dRgL0uHrZNXoJJgH+Z9h0z8cHd1eWQnvm8RtCdvhBkdfic40lQJkyiASSJ3t7QIO9A12N7RszOxn3QGTpTXoro5pDiVwSXTQ5rECBCDX71vADsQVks7GGSpRWDEiv451Yvi7rLGFOuLvkE1Xaxd/OVMyvIqhgKjS41jE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 09:15:49AM +0000, sashiko-bot@kernel.org wrote:
> - [Medium] mm/filemap: do_sync_mmap_readahead() recovery fails when
>   min_order > 0
> - [Medium] mm/filemap: do_sync_mmap_readahead() ignores VM_RAND_READ and
>   !ra_pages
> - [Low] mm/filemap: prev_pos == -1 wraps to match pgoff 0 on 32-bit in
>   mmap ra

Thanks, all three are right. On XFS with 16 KiB blocks the reproducer
still takes 4096 major faults with this patch, and on a MADV_HUGEPAGE
mapping with MADV_RANDOM it starts readahead anyway. I am testing a v2
that handles both and the 32-bit case, and will send it once the tests
are done.

The page_cache_ra_order() underflow is pre-existing; I will look at it
separately.

