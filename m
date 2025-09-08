Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E1D8CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 19:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2BC88E000D; Mon,  8 Sep 2025 15:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08FA8E0001; Mon,  8 Sep 2025 15:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40BD8E000D; Mon,  8 Sep 2025 15:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C45C28E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:57:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 709521602C2
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:57:08 +0000 (UTC)
X-FDA: 83867141736.27.819D628
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD682A0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:57:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=non3bGSV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757361426; a=rsa-sha256;
	cv=none;
	b=ziIPi93pTQol8TIxlBSIrLFkCegbu/i9cFql17yaxzMBId9FnSaPMv11YM+GmhHi/jmYuj
	dUDmY37C6GY2xM0quFe0YHCdm88JK7fiMSDJyBF4eYCR9bU7HHOhid6aV1ElLPIKRzA6+H
	sCNHeq5e/BH6nCT1Pur/AldEp+Iw6ck=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=non3bGSV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757361426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoLXbGMjxLNA/suFUGEkTpr9rzpTqZI/pHyN/Th1x4w=;
	b=V8IaQXaVPKhvZsRuWt3rAfE7u7v3fr2E5KOq/OwOS0PykUHHOfZDXEwx9nkmzJEIUbyWqL
	w+5oHlTM1jQbIs7eI90Wovkzr38pNnCfvGN1NmX4cEtGeYJKvo+OaQBd/yOo+k873xu620
	Oqf1PTv7ISc2ITPkTpIbe4S7NZKIIDE=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-724b9ba77d5so51715937b3.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 12:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757361426; x=1757966226; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IoLXbGMjxLNA/suFUGEkTpr9rzpTqZI/pHyN/Th1x4w=;
        b=non3bGSVyEQpRUDviXvdyn/uHXEJNi4zkNRjA+7qY/yw4gSoCp1VEiUjEqdLSojt/9
         Rn9tT9/2pcu/J7cO7+lspYEMfeQTN4AfETcT1hMscjh9zjUhVbeUwPI9KULzClZMzVCq
         briTNywF8CBaEQAe2JSbZh9fZ9fM2UXolNTDlfv7QDt+3Cd5Dk1AK/RNvntMv+ubnLjB
         lYih5ZJrboPaONcXhhws+wbnuQO9espaGjV/Xwpo3dGdlXiU/ADJtZQV0w1ruyPiozkU
         o7lohqQX5je/fn3Oh+CFfb82MtfE1kiVVXHSi0YG5qij2kJjOna39RaAxPVKnbqXZhhZ
         nN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757361426; x=1757966226;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IoLXbGMjxLNA/suFUGEkTpr9rzpTqZI/pHyN/Th1x4w=;
        b=LYJ0xGXp9Hy0wiBu83xLqc+qys63IqO0v4OADZX6wYK2DsYf+IpRjtsTTqXppcnx6p
         0uMSio0NZ7pOB/ylQelKW3F/juqo88G5BtExaEySy07u4MHzVRzQHl6eN8ilyAJI3v3F
         EsMCpoVl0fQ5Ls1P54msuGaSZ4vVle2LLfN7ghnU+p5OGhRLSwoX/bRFfba0JC0ZSZwY
         oLdfG/ehv5fTqMrA+1brC/BQoWgBn/ymZVRuNuippXRb9Xr6s7kSqlXzDaWMXFNEwbC/
         J1tSMJiXuA/8xap8V9O4F0KbjP3le/H/+JNISx1LaSUD7boykz3alWACqyqHZWk5e2Lw
         WJvA==
X-Forwarded-Encrypted: i=1; AJvYcCVAc/RPgRpLeLQwxmazzh2bevtHPs8Ozcdi7gf3g9b2uoLsbO8tN2lNlzK6tdyc0KxF/Oky7jL9OA==@kvack.org
X-Gm-Message-State: AOJu0YxlW/KQfZb85e9rxlR9AzR7Rn6jhGJHEsyIDLeNvS8/mfxHdVNN
	pju5hn3OfYXzIRsQpxbZ5MozuimOW8AImGufn0RP71zLLtN6dfM4JLtqptnsX6WIjg==
X-Gm-Gg: ASbGnctH7MrVi6f/0W/oKzzLWhhAvjlHLdz3ERz6UMRFt36OLdhO924YvV11OTkzxSE
	L7gAVn3iZlMIIN6urtPldWfklys/vZOmQaTzhbmhyykmCefTIBwphOhxuL1sJnzGHZdYcuOXCdu
	zk+op+dgeqk0ZjGgcunXtav3kfPL6Biu+Z8BG2+V+dMYz7qN/pb0O7dhS+h8oorrKEF6CVJc8Yl
	7fvUgaTzgCjMvhTmViRhgfU4p9uFSFdRvDYPP6CPOGPC7tCynkeksjCYpKAZ+ARuCfvPXORLPhm
	khj1TpbzjxmoB8zqZhKce6Q4Si20eiAMwLkk6h9seO/Qy4A6PcE3+OCnGGZ9elgjNP7Qly+be8D
	qNuBfTRySfCqghrTzUfuQEORu5LCbweArMCweyKCKeP6nkrD73U4VMIH4wDhcxJi+s/xPz225WV
	OF7YDIMD4jxXUgf3xDXw==
X-Google-Smtp-Source: AGHT+IEp/mRnH+3Dncw0ZHtHoBb2u3crhoWQ36w+MTA76D0QR6yb+nxhPQtfdxvv7OvzOG6eN8DgOQ==
X-Received: by 2002:a05:690c:968f:b0:71f:d459:788c with SMTP id 00721157ae682-727f368e699mr88931137b3.2.1757361425548;
        Mon, 08 Sep 2025 12:57:05 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5ff8ed34211sm5953906d50.6.2025.09.08.12.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 12:57:04 -0700 (PDT)
Date: Mon, 8 Sep 2025 12:57:01 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH 2/7] mm/gup: check ref_count instead of lru before
 migration
In-Reply-To: <1f714ba0-cdda-4122-b6a1-e1e0ea44b1f2@redhat.com>
Message-ID: <d5333648-7b88-9293-dc1f-e080dff65d1a@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com> <47c51c9a-140f-1ea1-b692-c4bae5d1fa58@google.com> <e54b1d8c-ad63-4c7a-8b1b-b7c3d76446f2@redhat.com> <b008aef2-f69f-e2fb-d4d7-71a42d308529@google.com>
 <1f714ba0-cdda-4122-b6a1-e1e0ea44b1f2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD682A0006
X-Stat-Signature: cj1h8ruh7xqrywzyu4rdc3szstmt3xqq
X-Rspam-User: 
X-HE-Tag: 1757361426-370606
X-HE-Meta: U2FsdGVkX18EkaD9yzxdvJ+qjvn/3kuWzpOBqPLQmhAFtHRwvyTOE+ayxiSEkCGDVM+EfQzyTMxvcbRMbe2QOPxWZuDx3VRStLKo1fwYsJ+AavrGuRFDDdWHJg0A0iaqAkpF/t2CPHv8+yWHiLK9I4++hLvBxvOF0L2cMLnVBt/GVRb/AAy4oaXvGiwgrKtRQlcBsXmhb0YpXuxYkBVZIGpfLkJ/KtOIM7n3uu1H/iYQFc8rCxuXlmNYhxGRj0vZzxbhHiepSBlqbDr6vAuqnZoXz3bxW5ZQqNcnSnI4xJhx7QgdodGy2eKaqIvHU9pwxb7lPfda0iqag3zaCQZneCSLyaFUstNUno4wl84T6f6IN9nr6nx7gWfz2f0Cp7qxjrQ/9by1O94OVeqF0U1Pxat3wbkBQlITtcHMHLFS7cekp1FHXkK2Knc04vXVAMrFlyb3rocM1H5k+EAiX9f8tdSW96zlBp2UIiY6hoOVJET/fWUTsEb8mHg/HMZcDSSJCeDAyqVC8PUfts+WQ5yVy4En/yWXMltDLmcJc2Ct8AHfWK/Vf+GvaVBVbbTrBx0l4Yh3q6KaZurrbG48DVvcI7B2F1erg/7ClAym3qbp286AgTIXGGBKwWApJDaLHo5UkDiAMG4YlytnCtqrrZOwfLIlnLydJnSMGbvn9x94HV+hI5GbIHwXOfIQozI3igggsSw+rSJ02QToqfsc1/0Wo1PSPK1PcNM/veQm1fIzHRPBdRqaotzTWPAvDO1O+uSjn/aB2N4k2SXPaiYj2erd48AsnjVSTP7Avgc1BBP6h+2ZIjSXWhKuCvdFhCHFkKEoaNfI+/mGy72GSrvPRwOeTPmdP4ocBNUsuhroV3O2jPOi3XpN+kvGa/hk47ef/v27niLkEFpkJ2z0+HlhB+YP5ww3/6jqOZVItCfKXqocYk5Abyi6oP5n5sCqs7z320v5ysF7uKpat12Zce976/v
 GBfnr/XC
 eUrnNQL/Rl6y8pzAvwoFPE8dOCxvfjy2NqhWL5ksHHiMuRyspFadpQ+XxsOAjPipKUf2e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Sep 2025, David Hildenbrand wrote:
> On 08.09.25 12:40, Hugh Dickins wrote:
> > On Mon, 1 Sep 2025, David Hildenbrand wrote:
> >> On 31.08.25 11:05, Hugh Dickins wrote:
> >>> diff --git a/mm/gup.c b/mm/gup.c
> >>> index adffe663594d..82aec6443c0a 100644
> >>> --- a/mm/gup.c
> >>> +++ b/mm/gup.c
> >>> @@ -2307,7 +2307,8 @@ static unsigned long
> >>> collect_longterm_unpinnable_folios(
> >>>      	continue;
> >>>      }
> >>>    -		if (!folio_test_lru(folio) && drain_allow) {
> >>> +		if (drain_allow && folio_ref_count(folio) !=
> >>> +				   folio_expected_ref_count(folio) + 1) {
> >>>       lru_add_drain_all();
> >>>       drain_allow = false;
> >>>      }
> >>
> >> In general, to the fix idea
> >>
> >>  Acked-by: David Hildenbrand <david@redhat.com>
> > 
> > Thanks, but I'd better not assume that in v2, even though code the same.
> > Will depend on how you feel about added paragraph in v2 commit message.
> > 
> >>
> >> But as raised in reply to patch #1, we have to be a bit careful about
> >> including private_2 in folio_expected_ref_count() at this point.
> >>
> >> If we cannot include it in folio_expected_ref_count(), it's all going to be
> >> a
> >> mess until PG_private_2 is removed for good.
> >>
> >> So that part still needs to be figured out.
> > 
> > Here's that added paragraph:
> > 
> > Note on PG_private_2: ceph and nfs are still using the deprecated
> > PG_private_2 flag, with the aid of netfs and filemap support functions.
> > Although it is consistently matched by an increment of folio ref_count,
> > folio_expected_ref_count() intentionally does not recognize it, and ceph
> > folio migration currently depends on that for PG_private_2 folios to be
> > rejected.  New references to the deprecated flag are discouraged, so do
> > not add it into the collect_longterm_unpinnable_folios() calculation:
> > but longterm pinning of transiently PG_private_2 ceph and nfs folios
> > (an uncommon case) may invoke a redundant lru_add_drain_all(). 
> 
> Would we also loop forever trying to migrate these folios if they reside on
> ZONE_MOVABLE? I would assume that is already the case, that migration will
> always fail due to the raised reference.

Loop around forever?  That would be unfortunate (but I presume killable).
But when I looked, it appeared that any failure of migrate_pages() there
gets reported as -ENOMEM, which would end up as an OOM?  But you know
mm/gup.c very much better than I do.

If it does loop around, it's not so bad in the PG_private_2 case, because
that's (nowadays always) a transient flag, much more like PG_writeback
than PG_private.

But whatever, yes, the move from testing lru to checking ref_count
makes no difference to that: the failure occurs in migration either way.

Hugh

