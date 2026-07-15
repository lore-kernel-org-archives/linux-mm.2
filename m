Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D282C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 02:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794C96B0005; Tue, 14 Jul 2026 22:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745B86B0088; Tue, 14 Jul 2026 22:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635076B008C; Tue, 14 Jul 2026 22:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC8D6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:30:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99BC0140502
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 02:30:28 +0000 (UTC)
X-FDA: 84989432136.17.374ADB2
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id BF949120005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 02:30:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HXdQZm7B;
	spf=pass (imf29.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784082626;
	b=VBcgwAJ+rorJB8nb6lgHk8iA+ON5FmJMmp+pVNzrpuwh7ZHx9LU9d6bj7zoGPWVoBDeo0L
	9wJAdb8zhc7AB507XziZyZVdogd3S3r8f44KnImk9C2EEFiK6dtO80/HOHiblPloEu/7fE
	EDKmLOzYZxQeoiCbwsymvXzLjnOg3VE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HXdQZm7B;
	spf=pass (imf29.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784082626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BW5Kv5bJabD6plflhFw2hxWKNygVNZsIWB3rMXkidac=;
	b=HQSzxxebW1ePiV2sBoSsLBHGIrQ+/F0p7BYM5mGW1zBVhkdX0tHCmB0S4ZFDhGEywT1+W/
	nmYGdFEoM4Ut/hONDhNF/4Q+Cudecq9cRWkrdkg0owcM02OH5omM87GBTBTTL5/CGxs65k
	cW/lhI7nwzl8zBVaRfGlwUjwtcwATEY=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493f60208a5so41732405e9.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:30:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784082625; cv=none;
        d=google.com; s=arc-20260327;
        b=c7BiZPcaFqrX1+XmpARAKu0TPfHbPitpUlfy/RZDqKBbwnFWL5UKcyj0MKyJv3Urdg
         CJgTRRwcHHGbJME+I931ZhmDqRCYAUT/cgdBzwTSv7/x9o9S7HsjyRfDQO++Ow1TIBXx
         lclBFZxJ0syh/UsD8lU8Z3zsMeVO7ldjKZrJHC2X0H8cLQhkbPY/RpddrAnZCxpFy4Lg
         5mKBZgrau9fOPXx+No+KPHiaILjmL1puUnZ8yQRwogNUclEeqDJNnBbri+wk/JJlS7bg
         kZujT2f7U1QoKWw7WVM58f03Lz1YZ6cKE7k2bNZAk9SBQG9+oKFuE26tAOJBEnSvJ2ik
         1UPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BW5Kv5bJabD6plflhFw2hxWKNygVNZsIWB3rMXkidac=;
        fh=D/oS7KMzwu4+tXtmMnO8TGn3Lv4f/fLrW/BbqBtPMeU=;
        b=fCabrPb8f6G+5rrjtJAzNikzjdiaLIuWPz1Hyx0eE4QpbXUAmf7t819jp5vRJAA5FO
         6qRBw9Wr0VvexBeMi9Z32y8RiPPcmoZvz6R6YLdRkoG7nnbiFBinUEYdWrBb3GfYG4EC
         SEI6vqnehRTsu+0Jtql9P/0pB/OKGGSAsN2i/spMY6YWhWMrBU8WjAgEvIrjxMcHVOli
         ZKpB8ayWVAMSSq4/770bzcT8/QxibukwWKUkGFo1pU4jtATUkPPMoUp/08bpTL7WSnOE
         C82s0t4E3O7nKxjZTDNyj3gqr7O+e7av1HgyXQi3LMxi0is59fP1wBPdLjFCqKM4kNoj
         k47Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784082625; x=1784687425; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BW5Kv5bJabD6plflhFw2hxWKNygVNZsIWB3rMXkidac=;
        b=HXdQZm7BAjBnTgtmXlZ1t0CxLfx8wXLgZBK1JU7S14MA1D3EpeBEpuMRfzNkpqz8SA
         ufYNQkfA2+QWzfclX7rIhCOcTEe3+Km2vbB5W/diZAjNBcPgymVmFvsyMaGQe0ydVjkn
         ddFT9luJfSWv5JTXDWTfEsnEZHYGyVOkKVVh/6jkTICOVxUYxgDPJUQ697bHOfMkiu4E
         Hg4heNvoyKGOJy3F3dCZAX2160q2vl11zPxSbS3yGILcwfwOFtQt8RVP4M6CCmvzqMgP
         VLAt1gmuLqkBL+DLDNr8/POItyjqp3DO/v2CQmOrDr33NPkcqj5p+JDXtCH5Kqjy8UVS
         HnaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784082625; x=1784687425;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BW5Kv5bJabD6plflhFw2hxWKNygVNZsIWB3rMXkidac=;
        b=E75G2D2U/LNK7naWJ80W0L5cqHZxiMjrO7AD8+bBYqE+/oxlvEAdwJOqXRKR53+1r/
         Vu8cu9y+jx4vQ01xEDTHDpyZh3KYwCwy87rcGb9rYHRSU4UKtf9dkq8tnABCzsi3X1pr
         xdRo0v6UMu23qBMWXes7txBHXy6GesL5Jhm6FgW16D7r5CsvPtM90zB6q0i7HxsEIop5
         QV073jW1DQddSrQKIRVOhmStxkFR8/Hj+9tIBD39i3tkFW8F4ZwyfBnC1ZK1RQeM/CNg
         9ltTYwytxP3ZuF9wByqvIVgOwepNdjL0dZD8HZ+c9oKTF3P8qDucVFuCRRVpoPUapkdt
         jCoQ==
X-Forwarded-Encrypted: i=1; AHgh+RoXOHdBbqkGUELwV7kLnKVmLLNJ+/a0ymhcSkFI7THGmktNnuR4FgOLluu8CRSmIHzouxfVb+7Whg==@kvack.org
X-Gm-Message-State: AOJu0YxEpvpxL+xkklbkwEx8aAabVyL3etGR+RWK4BD6HidJRvdAKAo6
	fayCxWCcKERYpwfvJDBRfruHNvu97kyYNn6pnad/ZUQu/88TJw+6yMLvQLd1DBngTlIJV5NlnF2
	oeUtNH4ddF3b+Amxl1LlhT43ql4hQBDY=
X-Gm-Gg: AfdE7cmWT6jD2jI6MHqXOwjpYix5bUidSIMabi+HGgZEbLit56qzSQU5F225s2W/go7
	ySDozoO0B0MLPXJSiT1KYDioYCpLX4qmwQBZHjZ8KCr2gV+MgagWnBCECVWweJCzlK1h16ac+ZA
	C+1KCG34ccXAv3Uae9d1UUAgI7RrF/87kyhujEeeXTOiR7B4k2vnLUxoh34UQS1c+9CVkf/3h4v
	wJMRvxdryd5wpUPko/LV4lHI1brM20yivv2AncZj3KADa2vJziiI9sXAosCCkLbfTSdvp6T1EB4
	UEURN+n/HZ8Gotf0Lu/108P9NYXT
X-Received: by 2002:a05:600c:1d1d:b0:492:4a56:690b with SMTP id
 5b1f17b1804b1-4953c290ecamr9140525e9.35.1784082625136; Tue, 14 Jul 2026
 19:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260711043946.68421-1-ahacigu.linux@gmail.com> <20260713112001.GE276793@cmpxchg.org>
In-Reply-To: <20260713112001.GE276793@cmpxchg.org>
From: Altan Hacigumus <ahacigu.linux@gmail.com>
Date: Tue, 14 Jul 2026 19:30:12 -0700
X-Gm-Features: AUfX_mzbuZ8kodbWEal87MPrjxwkKfqDo39bHZt1sfxmQQheGH852D8Hiq5D1Is
Message-ID: <CALjTKDkFG651PbreBkDjB_=rKXOrek4b1WJpDjfTY=385z__VQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/vmscan: clear hopeless kswapd when global direct
 reclaim makes progress
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF949120005
X-Stat-Signature: gmhpns6x14pqsxegxk8cytitojrm1y6f
X-HE-Tag: 1784082626-714926
X-HE-Meta: U2FsdGVkX1/Mc9+7UzH1QhE0YubMFwDv+9MUHCr/A9WqxH7obkdUApe8O1kVdnEQ+YudgTsXlSOWfYy7x2/dQxeCbHDfdpjQYoMgbEceLQgACk32q/38/5wUuKdjq48EFtjJ+1ZyE6sO4U8b2uaPCWeNRoptazYbUlR6z76NqPGbBJP3ex8m2DcdHKbnYSEoT/QxNef/YjJzyXrVSS3QCs+E3lsGwDy3rPuHidjwmgnGozd7jUSwtOKyuevJRED1lkTErGOq3jWCV6RsmMUkLXaYnGdeIll7AiEieIuqqoahS5azP3z7EwSfqFDGx29h6tp4in7I44qoPSLjDtwrl+VPMDym9MJLxTefIR8iS8zhXiG7NJITG8Q5d/T0KV49nzg6XKeGcXTdn6k0lheEX/mfW7uFHu1guZUF3AtQ9Mk+fwCUFHj6e1N0Q8j3x+bQSSbuzgQt/AbRbXVHl5Pk3fhCDZ7AprfjxlAuzYD9F2N3rbyyb76sYViGS+IA/pMR8GIGbKSJIApdhaOCx+3ihjLM1OIlFLmTTUMuehwTx6ETj2TO1GYSGlGXOgVRpp1NUkfGuA2t0cIKfqXidQOTdYh3N1WSfilWqU6MtOS2Fk4Mh9jY8ZAj/XIlUDphVmNZljquxyUT8VeTZqMvcxxOWSVDGlhHsMTiMx3nUEbEQ2HzmqiIU1OnDIo25H+jo+cJH1i3OMYXWHz45MFjHaIJ69p7+Sl3ymnLWi++yBvQyZJzuPaPLjenS2/xAp7vsuZVaS3i36fZ106Kq1xRAvKfM10PWFiPZojL+iiCCKxn1zx8O/FInHVM8fDRDqQjQIS9W+Bi/9mSd5U4GuCLsI23Im9Lnl4++qHmI8lb3cWMtp+BnyioWwn3RBe9bP/Q6jJimtR7EaJVdTy8mRAdbmEhvXSefhSWTeGjwA5XYaGIM7wpOXQaUPqgiRcwrmRntHrqXYFwz70gmBp5fBs3t1B
 DlcvPWzN
 yu91u9BcnQZ2a6o5qQTxMrmqZexlq1kPMyAtiGp73nvYP4VebRJ2OtB3y3QSfAHicKcrSkfXa4Ajtu03EBNigOApDEQDY2f0n2XOSn5zqlDqISaoVDFf6P4cQ6UqWcbPa7LOoFgt+k5tnFpbF0HCv/SWbXnUFz89HiK/oIipJaUJhUj6Zfqd4mLYsYqRK8LuoJmt1ZXkfvBtVkRa+kv+SfYd3zB6GJBoL16Q2UrgGkkkRpGI7KK2/w+2gBkFxKe+4MIqW4EH8d7FGO+yLxl8qDtBF1ONkE3zYf5O6uiII9LBeEgIYJNGKdiKEpSts8qwWB37n6GbuhbCfyF/yd0gJcvTKeEIF16E6H8ZIcThcg9nkcihiaijyYlM81Vm1h1lzKIld7s6yF4oZh0lAPXasm/1uG/oQp435iP5wZ+sg3rw3KbjynR2qd/A9F5MAUZlUxEQwCqKjs7Yz6Cs/fuhT5DSEL7PST88OTuFEcR9SPUcfH10DiuYxUfDanw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 4:20=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Fri, Jul 10, 2026 at 09:39:46PM -0700, Altan Hacigumus wrote:
> > Direct reclaim clears the hopeless kswapd state only once the node
> > becomes balanced - added by commit dc9fe9b7056a ("mm/vmscan: mitigate
> > spurious kswapd_failures reset from direct reclaim") so that cgroup
> > memory.high reclaim cannot repeatedly revive a kswapd that is unable to
> > balance the node. Before it, any reclaim progress revived kswapd.
> >
> > However, this restriction also prevents global direct reclaim from
> > reviving kswapd. Under sustained memory pressure, global direct reclaim
> > may continue making progress without the node ever reaching the high
> > watermark, leaving reclaim to allocating tasks.
> >
> > The effect is visible on systems where a database workload mlocks most
> > of memory and the remainder is under continuous pressure: allocations
> > stall long enough that ordinary tasks (e.g. ssh) become slow or
> > unresponsive, while kswapd sits idle.
> >
> > Unlike memcg reclaim, global direct reclaim follows the same node-wide
> > reclaim path as kswapd. Clear the hopeless state when global direct
> > reclaim makes progress, while continuing to require a balanced node for
> > memcg reclaim. kswapd_try_clear_hopeless() becomes static since struct
> > scan_control is private to vmscan.c.
> >
> > On a workload with most memory mlocked and the remainder under sustaine=
d
> > churn, with swap enabled, comparing the same 60s window:
> >                               base       patched
> >   allocstall (all zones)    413441          6532
> >   pgsteal_direct          15889552        255619
> >   pgsteal_kswapd                 0      26079382
> >   PSI memory full avg60     13.10%         9.37%
> >
> > Direct reclaim was already reclaiming many pages in the baseline;
> > this change lets kswapd resume doing that work asynchronously.
>
> But does kswapd actually stop?
>
> I don't see how you avoid re-introducing the issue described in
> dc9fe9b7056a. Direct reclaim picking up a few pages is no guarantee
> that kswapd is able to restore the watermarks and stop running.
>
> The distinction between global reclaim and memcg reclaim seems
> handwavy to me. Either can free a couple of pages on the node. Who is
> doing it has little bearing on the question whether kswapd can balance
> the node and go to sleep?

kswapd still stops for the same reason as before. Its own reclaim
progress never clears the hopeless state; only pgdat_balanced() does.
If it stops making progress, it reaches MAX_RECLAIM_RETRIES and parks
again. This change only allows successful global direct reclaim to
revive it. Whether a revived kswapd can rebalance the node is not
guaranteed - nor required: under sustained pressure the change is about
who performs the reclaim, kswapd asynchronously instead of every
allocating task synchronously.

The distinction is mechanical rather than "handwavy"; global direct
reclaim follows the same reclaim path with the same protection rules as
kswapd, whereas memcg reclaim does not: reclaim targeting a cgroup
ignores that cgroup's own memory.min/memory.low protection (see
mem_cgroup_unprotected()), so it can succeed where kswapd cannot. Thats
why the patch gates the reset on pgdat_balanced() for memcg reclaim, but
not for global direct reclaim.

