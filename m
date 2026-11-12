Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62AE606A880
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uHd+VGGZ
Received: by kanga.kvack.org (Postfix)
	id DA0D16B05C6; Thu, 12 Nov 2026 08:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51AB6B05C7; Thu, 12 Nov 2026 08:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67906B05C8; Thu, 12 Nov 2026 08:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92E116B05C6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:30:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E4321A05F4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:30:59 +0000 (UTC)
X-FDA: 85426552638.15.0FF7E3B
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2B8711C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:30:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uHd+VGGZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794490257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1xZYGW3sp4V9GD5hAamXepdrQgJ2mYyugoBZizhATM=;
	b=8eN0MvdgaL60hIxqHcZt+nATEPNN7hf0vhGN/b49x8J5FrsX0tnCkCkVlEpQ0pMAZ1X6x6
	eRcT+CK49wdn1eMLwUdrbx3x97kQNGaA3Ap31V+JwYoIOwGm0NW/PhIPVCatRlFnJgv3jZ
	Sprg0o4F2h4j2NQTOaO5Wh8+SOAdixY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uHd+VGGZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794490257;
	b=kxBsjpxB66cwsjwf4B6To+hUEYh+kGu9gXmv+fM3q8V9XdOQzB5xFy/tqYqdpUDGpQIaBk
	thneOjo2Uep/VqeJ6k6WDniP3zJbNphDvlgaw2J60tCLFzcHh1KdUF8Woqz8GNzu0IW7lW
	P2upRqJW9+SF9fhBCdonwHuNKn52qWw=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-490f38e9688so762484f8f.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:30:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794490256; cv=none;
        d=google.com; s=arc-20260327;
        b=mlfaXDUo1aEty/P2+2/58wjz7ISSUik76srdTvS5iqqOAeNQe9kPPrX78GurMaaJ1f
         9LXhqa+qCeiyNMeDmKV7PwJNC0x3us2c/20flvhrIGZpJxE+XsqB/Enn+gNTkiaFBagR
         /Kauku54M25k+F9CukUZVV+bgt6G6e3LTpGiox6hK9nLWuGpKDXLnd71mRAWcda11fcR
         tnswZieWrTL9AO4frTvgIye5Rjqopk6ykZYPshsttXHFbNfU7ZH/WY9AUlr/AeMFlshZ
         5JDqod8QSz5st2MI24KLSVpQm50S/RKhlBuRcVpcUElvE4whi4LwGty20j4+33T1C7ij
         Ox6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S1xZYGW3sp4V9GD5hAamXepdrQgJ2mYyugoBZizhATM=;
        fh=TV9+3Y6htsIam4H2yxpvK9LLO1Yuc8/H84V2EoeXgtw=;
        b=haXCUOG/lY3gDIr6PmyfsRZ8AcgQ9SiZ6Lv70s8/CYH1g1a3Dy7fkZFmKhfaWxvjmo
         Sbu8BM4hHowmrYsjlofKHZ9+bqSupu3/UzYrWkp25NytGTaCadQQIG7lQgKGguTmF3ok
         RfjsL43nV/pMw4yyEOOpSF7bCwpI+w9qrNJpllZTLxulQkhFnQu40Z5OdCrA139nxkoF
         aAwCxIVc5BGwtZenjBcryPDNLV/cqMFpn+ReE82bba4cpn7xJVQIf0qDyfitqntfl6pg
         9QvsuyEd0ZV8Hm5s7MSmjU+y/REQsgpXyJHdq+mRol6jmPw99Y0VI3AI8pGpXcsWQ1JI
         opzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794490256; x=1795095056; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S1xZYGW3sp4V9GD5hAamXepdrQgJ2mYyugoBZizhATM=;
        b=uHd+VGGZrZ1mP5gnhbFmqVftxHpTEenu5jjXKaWTChRRTWxi1vq+bRgY/LabKtJscB
         UD9EQGNKu+XCqnb91/RuCfEKjV6rCelc/HJ06Ppwdmal1fc2omP6qk0pDcHTTcU7roAk
         w8p9x1qpBLKne/tts1+u7zKiDkf58dt8emnj+4jdSLbfvFN8GrPTGq+5C32Dv/Pt1AIA
         57h7xDxHNYh4lm3hpFEoCCWzM5y8bwKBYPuVzy6ePVK+Mj3xWHrqAsJrn2fZc3XIR8IN
         fz5SntyU6MLWtJhgUy0/8deaN2MLn7MpglZ3TgZVrH8P6Fh5h0yjf2Nx0LokRZFSBBu+
         5YDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794490256; x=1795095056;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S1xZYGW3sp4V9GD5hAamXepdrQgJ2mYyugoBZizhATM=;
        b=1+fw1ENfWXs/IyNPtuD0PrYpV5nzJ4UlE9keBs3Wj5hx5+zKbp2If2HKgJR0kzMq0p
         rzn02nLOu0SAGmUEM/K3hsjdooH6zKwB8UJ3+TdRlIhjcu3YMtYobwdeLaqVmSihlSYW
         lmxcvaFCkRPzKPZscrBfpCZ4x/ArOnXxXPztItVUkmeHJOZFOHplxqG+GrN2HxY1MzHI
         lVSiloC31X9u+qKAMo7wedb98JWFKTAypSO5AyFhsQXdgT+yqpqbMsEM5y9Gf76NkFWj
         fvQYjHGlq5Dtr45rUB0+RD9p8FAeygNKEZ566z2IDPMqH+MmD0M6UNzKes9CnhuOaLtP
         ss3w==
X-Forwarded-Encrypted: i=1; AL+hErHsfwXxIhl15hELpxozg+2QZ35m2isWZggIo0JUK5OJBzM7RkPNfCShSEpCP5mSd/tQVrlwApQYng==@kvack.org
X-Gm-Message-State: APuU4Z/8S6Jjr+5PksC/Txxo/OW9HyppAaWK7+NvUPPI3SrTdJl966NT
	/tROEKZDJY9ksuYzfvic3AJsCB1hJ0CkBkpQr3ayxLZoDZTj5b4iWJ8B/KQof9VqSaXT0PbcVTY
	QQiXJ4gjXydKKgDSxUiAl+e6lVvPAMs8=
X-Gm-Gg: AYBFou2+qGi/93Uhf9ezgSddD1Lb/OvD5cSNyOj1+G1X4o/gpjmXR1/YCvhp0rxcU+w
	uNw3KToGWmYvzvOiHrO9HErpDVQg9idC3tyYDECgahlq4rMpdEYcNuYEjJ8LmipgbxRdCHdA1d+
	alCBBovQWUgsHRYjJezahC4hYdNlq/BEe2fSVGSqPwxiSHO/ZBp9FPL9VvME0/7CVG4daEWvFa8
	Orj0OOaEhkD5+n4kOvhi74qBSvj8qElvkZZQn3SOJ687YbLGrv6rMM09kTTAEshSuDDFmwD6mP6
	UWU9POUH9lICwCtvCnppDrpmo5+pxmfWr4E+lfgxYeqCxpj6hdwWdPyQxZqymq7xyNSIVOJJB4B
	ciZZFZzlQhFRdcLwm8yVTaB1CeV/FqsHc4koZpTdP7jv0HOkr+63xNxrIdaRIktsNC2sFFP8wiI
	ZAoMp0HiVOJAkLcZ7Ll1i5j57kssNP20leL2efP0xR3uszdJbAuK8OGoZm/BCohJVHN0nmh4c8r
	Q==
X-Received: by 2002:adf:e00e:0:20b0:491:632f:2c8f with SMTP id
 ffacd0b85a97d-49afe168872mr4263229f8f.2.1794490255492; Thu, 12 Nov 2026
 05:30:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org> <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 12 Nov 2026 06:30:43 -0700
X-Gm-Features: AclHuK_EMQbfmXamV3TaIqS6catb5--28CKUD5GkvfpyfyoaKenoCKPieGjScZg
Message-ID: <CAKEwX=MDNW=tj5cfSrAN=VG-NEd2cax6f7QHcPfGDc1vTix+TQ@mail.gmail.com>
Subject: Re: [PATCH 02/13] mm: cachestat: count each page only once
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, 
	Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2B8711C0004
X-Stat-Signature: 17k43igkkzsfotq1mjaz4mgfzyegi5hw
X-Rspam-User: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794490256-890383
X-HE-Meta: U2FsdGVkX182emPmm/2fMT6KpKgQ40ziIpdqtoha/3zbefCzJuQx4YefgRa79AAaX06blfnq2Yi0lClVz6kwb5mbUp/0Brv+qza35m3hRBbzuccPfiLJ87PcQxelx8LujfSDT4244oaHLzEeq3XPr9JJPed3gs5wYHPmi+W6a31x/JsyGhe6NKlhu70KavUJXruVFVS2b1lDnJpH8TXa4RsSFGE9oKs4q+4LprLbIiRw4LS/Gozs7i4tbxea7tA1anW+KASHpT9iVGRSZo3hQAt6k+0LW07Q77Su7Xx3Wd/+19PQK2fEJFSjzjwBSLLEOTVHMEOVSjzxJ1I+1UNK+hnwvZpseiBekSttrI1DJCen0gDEji73NlawgP3Vau5FRqROjdk8yklLYIR+cgG70+AX2q2YPqxhfGQAOv/GTobCPZ90I3caHRv5EnmPYpuXdUjRO8frnQUsiqSmWRezf4Fzut3JP7n8NwJg8chvU0e+uublZaKOBnlpy3awYsomFO0fyrW9RILLyPyDw6ZpfycGrZoTEidiVDXSGeR42SU/B5ahSxzB9R1OLmsnQaVDaOr4jqjU+559a90K+rzA8atZS+632R65x561bT7YVa+IkdzCAJyARQgHvLQaSj1xtVQ02h/qRAzorTTg0M8tZbD9rfKVbc8qU0pT/crtZbDiN740pZ0TefBZkLjKr5IWaE379Mw7T7TGieuQVC4shURfEhufrKEcZMYNM8EHalOQB2dANxRM8u3EnbBB6cKCAfU9pxzU8s4o4gyEa4G2JDSJfJYa0k1fe+gRM7LT5W8y1pCk9jGCMXjDVvAyMrOWg1IzuZJh11x63nf9TAX0umvdR8LMnxBpl9tXqEL59f3glwTkYdQVeyCCx+Py2uFOzTAh81ti9YLgmNOyH9B6BOUa793u8LgYzp4H7yI+HEUqZP3ijZGA6hyjZXf6oifEU6N8+Mruy0MZ15mERwb
 NBPR4++C
 4czPEH0/wWHqJ+at2ZMf0E/GJo3csd2wm983BWnGvWWF+zDio7CaOdwhsiQxIwVAJca6dZfSAvuPUAYg+35pXC7nyRQv994kFi+KXkVWtHeN4csdTMntfABsMI2fEWFN2ZbKYOUc/ix4LSlTzd3yOSxE6JDDzJj8pf2Gmf0yzaZwIf5rtcNUmyek7e98cI4EnXz3R7jzgPfjUd9wsLzmPRp/xnCfrcRMccNTQY5XNrHm+OAH306nKVZLnaHVsXlTqp7oOndYWZrco94ngz21qH5ap0ZKtFptWwePgo034g1sP2PHhDe8H2OWRJHjBg6N9Q98K1sNmNXqaWkUzB2yXpaklDqqUM7akaGL/8M/Jg0J35jq/VPMxz4EXuakhdWnzSYKvAIXjn8AKWfCxaunjnMRNLWsg2ih/tQspMa4bQh6wdZlFBC3O9UahP+ViFScwfolhRdhrzyqBX5P8IrpIXXyu6WYe1wYcZ0O8Qk//GhzJKMi6fYLsyBIsFtJ8NWiYT7ILSQIAsKaNAigtqJXCBtGYIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 11:14=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> From: Chris Mason <mason@kernel.org>
>
> It turns out that filemap_cachestat() can unwittingly return incorrect
> page counts, if large folios are present.
>
> This can occur due to underflow - nr_cache is nearly 2^64 on a 64-bit
> kernel if the input range starts more than 64 pages into a folio that is
> split during the call.
>
> It can also occur due to pages after a large folio being skipped if the
> range starts in its second or later XArray slot and the call reschedules =
at
> that folio.
>
> Finally it can be caused by pages being counted twice due to folios in th=
e
> range being split or collapsed during the call.
>
> filemap_cachestat() walks the page cache under the RCU read lock only,
> and for each entry it counts the pages that lie in the range. It does
> not track how far it has counted, so the counts are only right if the
> walk returns each index once.
>
> But a large folio can be split during the walk, or small folios can be
> collapsed into a large one, and the next entries then cover indices that
> were already counted.
>
> Resolve the issue by tracking the current index as one past the last inde=
x
> in the folio, and explicitly using xas_set() to set the current position =
in
> the XArray.
>
> Additionally, add a check for folio_last_index reaching or exceeding
> last_index and break out of the loop if so.
>
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: updated to use curr_index, fixed comments, updated commit message =
]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks, Chris and Lorenzo, for taking a look at this!

Acked-by: Nhat Pham <nphamcs@gmail.com>

