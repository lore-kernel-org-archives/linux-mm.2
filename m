Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D181CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A20706B0093; Mon, 28 Sep 2026 05:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A99C6B0095; Mon, 28 Sep 2026 05:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899BC6B0096; Mon, 28 Sep 2026 05:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57A2E6B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:53:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3E0116014B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:53:56 +0000 (UTC)
X-FDA: 85262709672.18.C3E9B3C
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0814780008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:53:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jNHX9RK8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790589235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJTLKL9T8vepgzmrMMl9hUBXjorXrkUQap53+72PCy8=;
	b=qbFs2Yz5O/K2dlwvky0z71hYFT2FaKa5ywctc+jn9oIVjwYtUOUiEl75+YG3VYDBCrpfms
	FiRUT9PPHOxpW6aCRS48sSYuc9rnYZPRpEcEGUR22Md4x0+a9d0v6l15F6aDvnKZWWLdqN
	XkSrEHtlL0O5qAn4Rvv5UP89Bg/Wsy0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jNHX9RK8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790589235;
	b=wIrD5w4tk3Nx3nohSJsQ3uo2PBWy3GvdMPksahVLmhRGZXdwNDeug390Th0Xy+C8UmhNjq
	PKzkAPSGFi7wWyjxtF98tZN6lADVUDSwR1ytAGwSc3Qg2QvoCPD5T0B6wd8Abk/exf4Do/
	HQzRqPvyih6Le/XashDdtUEO5hgnUSk=
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af3a4f193so284446866b.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790589233; x=1791194033; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mJTLKL9T8vepgzmrMMl9hUBXjorXrkUQap53+72PCy8=;
        b=jNHX9RK8zY34NZS5Ctc32biKB5Erz9fC5NbRjxrC0G7DnrmyvbFwBby7jJ5LkaU0sc
         23dBpMn9s+Exgtey9bdeQVNx398ELHUFqdlEtSz+f7XQjrhWFxMOf8IJVlwW85YrXZ/g
         Oj4yKO/LadKuVJluXvCKwbQUPRka3E5uMCaIgn+lriZKWEZrfsDjWCjkmq4AdpTkPYId
         VydukEzro5fMVDsTzo64ktn0f7EVfnx4W5epSzr2nPmiYqCdUI0AKDLx2yGA8JjtE3NJ
         3GkEy7rqqnxS5/yF19T+1qL2azaVudPkqJmnz3IdD/Tm8I+XCoq8KtR/MmchIsXMg8wP
         YSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790589233; x=1791194033;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mJTLKL9T8vepgzmrMMl9hUBXjorXrkUQap53+72PCy8=;
        b=zMyqW8u2OuxUSQuzakR+gAzQj76EMtNd8LJwg8XN7v5xy0ni6WI7CQvN6nH7prProH
         hDzHEdPksyWqfHYCYXVLhJ/c13gVh1Q9qpb62SUWJ716YS3FfFqRuuLV2l1iS3jfro5f
         446uINYpM6sKzReoEu+7WrpTr6NL5UJoHVNtFTWAge+mU9/mTdYJRXaJMg6ZOFQB2R+3
         TGZ9lTeavrN701zTGKY33QyGmmTMV9GIJSuC94TWqvP7YcBP5/qMQu7Ielpe+14YVjm2
         UaQGn3/tZo41EQJOiadQrXb1tDOxcDrSld5UGcv1dSJWmhascBVPEeFntuZMSbZyxiTN
         dTpg==
X-Forwarded-Encrypted: i=1; AKwUvBxsMtjJRmUp05VDayKOovBtmbZ34A8oiWkcIqLbLKCc7O0JDN6uZzCO2x3tDjRI19XDZw7goq9nZA==@kvack.org
X-Gm-Message-State: AFq9FYIvtML4RI9a6+tThJ5LVLymeeGbJEqgE770Q1YZfRvBfz1eVfwv
	8W9CM1XCSqFgCIra/ga18sQQj3gC5LwrjTaT9HS0KJK1Xf1xM//L1nt2
X-Gm-Gg: AYBFou2U4AnloqGzqsgVqLu+Df5DlhDXrf9IJKaevjTsglk/sI6R96TIIQ686Rl0C4/
	G6dfGYERgE74fezd/9iK/E0DDdOVbsa2aUrYXO2Dfq7rIo1YVv6U2P63CzIj5sA1MHPrgh+x43e
	wcKLc1WWxRAlyGaRSq1mGlSoOZcnAY53cFGXQBTcyX6AgDw8n4jnI4wzs3dv7HSv9/u5nJ4Hp5A
	MTPaogyFV0RLw2G8yOnagVB7WCLCW7KCpNJAtrAzUzO5noplG4QsAo3QiDjl59m/S4jG1Xu7ipo
	WCZT3yZfImcCapXLAtPwEcudV8lsrwu417lMjn7TE+eRXSG0BumRqlGpgOaEPKTpaU/7js/xtzc
	NEyywycr6eDZnx+S+KJoD/Z7fvi2nuai/P8vcX/VCWYiR4EgpT23hqxdFkMRbCQVsMgGBSv32to
	QOIkp3bidPihHAcHaR4FqaIvNJ9SsepDFSP1k=
X-Received: by 2002:a17:906:2083:b0:c2d:5ce0:1061 with SMTP id a640c23a62f3a-c2d5ce01e9cmr243001866b.21.1790589233412;
        Mon, 28 Sep 2026 02:53:53 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae678c90csm466121166b.6.2026.09.28.02.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 02:53:53 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 28 Sep 2026 11:53:51 +0200
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
Message-ID: <aro5L-W-439tTICi@milan>
References: <20260915070001.113559-1-hao.ge@linux.dev>
 <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
 <60642a7f-2949-428a-8290-40d69c989a77@linux.dev>
 <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
 <CAJuCfpGeRdFY6UPF-vXxwHvP2+tN=BKgRkmLR3PMLuWhxgzPRA@mail.gmail.com>
 <1dff448c-9cbe-4276-bca1-d91283b0c7b4@linux.dev>
 <b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev>
 <aq1noAdz9U3tXH_Y@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aq1noAdz9U3tXH_Y@gremlin>
X-Rspamd-Queue-Id: 0814780008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ycg3jkzz5kh8h7apz8zntipqhtc8uy46
X-HE-Tag: 1790589234-88997
X-HE-Meta: U2FsdGVkX1/hAcWVbc5uX4eqhxDTGJYqU7H8kwJA44p6YlhGCV9BWS/ynohCFzIH8f1fXvd2uiPjHLPFu4zu2Wg2iJfK2aDEQSxVhsZ3bv+qP8E5dZCThElEzPTBBLCmEDtdcBEgGQ/v3ROf8TJTeZYUkAwjb4+U4lC2ughYwL3i4ryureFhoAi5ANdHc70JC1RbjYp0K4UAjiwBzrcHALg6pSBjr7tHdM6C3dXya7i9Enre6qnq//LLguuCyOKISQn/WI6dYZfpB6RNNWqQ0EjvYrLiDypqcSF5C7fbWBNhTLFRF/tDzULV3L/wxI6kI80iitqzPBo/4Qg2n6qR+PjLfAXoeUkv3lJKhMIFmnWzX7n25TFyiMaoIaD68RBnk7FthJec1d6/Boh6poN/kuUKze8r0BCPLN2ayOngqg5SJ4Td0ThljZF1Wd6ik011YN27AxtVGAoG0AuPIwY59Z8v8JVsnE6uby5JgAXJjvEJKHIm5OIUXfFoyfb78bMEnqtkKZu9Kq6GI/Xi9qvQn1Oq2mQMzIfJx2u2M6QZbsn9j6JNFKJ+DDcuVJ2eGd2x8Gn2XNQNOpuHud3coF+dfs/O/x6eYYNmBOF2+ilx2EV47Ko0R2BA8iuYsy3Bu9IuiE74+o8OcMV9DqjU7H1VSIbX8dMISY+3nkw0nIDYS4f9cNDtj135YS61hL/TN6sCWHrCzYl3UPGpcS6el4NuMFp9unBI2ux8qc1GgAF3hLlTxlFv8rCoiyXq1xtVXrwaWNOp3ERPrbFYxSg1ixzk0AtMKJ73Ed+eZgrsGWduIxJP0Jf3lKOWpZDvMLlDHULudbfd9CJckjIh9WZkd6zm6KghmxdJdA/GZzz/KSZ0/2UwM5NVBVuYw0F3MZIb4XPSumvzUAazQpbvA7CNKn6BCMIAxpkzVgCWWt7M0dfZdeEDVclPXDPFitlQJp+ujra+9+vLnb/pxVnbP/AQQpi
 TR4A7k6D
 LQVLvqN+zXcBydWC/BJ7O4SHT5VPPEu1COzA0rJdM2va7KB952tRV5yXWm72vPaodrSeUs8nVhiHeAtYyo7VZ2NVyQ0EPoWL5yY6bC2b2BiPT/pWTxBANopRHazEzxf6unatj9BWYA5xzACYDEbBxrCVv9eFZ2ZEv0MUWHcMqQkxks5jXR2xHCD4aRXKzeqIeiGGK+twoL0zjqaG1+ehNhv8DYu+Mq6GTwfh/2mvJDlmoJvihE1mvGSUdR8QUr1AkiI1cf8qv9INbv33J9mkp9kMSz0ABcnlomy3fw5yhUlMZQcN+SbI2A78uxfjTObCCqOyIhLbkZG9ZeBiiUhnRcUHGWAq8IMrOMbogqtRfZWIUF6UNBSSkvyQnwnJg56eZghCl/fSvxNBXoedzy5tWCWBKjvm2qKr/uT8nu41BJ3Mmbd8fwPbkt0YoIQd1RoskjiIPTaywPaRQ95kTNIz563tP9NtwEJX4urgBdJnftqpjrR/p6iG8mWcpLfdbYHDumRsQ3INGop3SfeQ2fz3h0tmtYi8VpeKe8oZbyKNqiBqdCDCWttNF3ooebprdxx2wvYOV+Ts0pGzwl7u/ZuwidNWfHpZ6FS7I4JCoyO2mnGL30yA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 05:35:02PM +0100, Lorenzo Stoakes (ARM) wrote:
> Looping in Ulad who is best placed to respond on this.
> 
> Ulad could you look at the below? Thanks! :)
> 
> On Thu, Sep 17, 2026 at 10:32:48AM +0800, Hao Ge wrote:
> > Hi Suren、David、Lorenzo
> >
> > On 2026/9/17 09:12, Hao Ge wrote:
> > > Hi Suren
> > >
> > > On 2026/9/17 03:07, Suren Baghdasaryan wrote:
> > >> On Wed, Sep 16, 2026 at 9:31 AM Suren Baghdasaryan <surenb@google.com> wrote:
> > >>>
> > >>> On Tue, Sep 15, 2026 at 11:00 PM Hao Ge <hao.ge@linux.dev> wrote:
> > >>>>
> > >>>> Hi Suren
> > >>>>
> > >>>> Thanks for you review.
> > >>>>
> > >>>> On 2026/9/16 05:09, Suren Baghdasaryan wrote:
> > >>>>> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
> > >>>>>>
> > >>>>>> The reservation is already stored in the maple tree when
> > >>>>>> vm_module_tags_populate() fails. A failed load never unloads the
> > >>>>>> module, so nothing releases the entry. Release it and roll
> > >>>>>> module_tags.size back. Without the rollback a concurrent load that
> > >>>>>> already passed needs_section_mem() can reuse the freed gap, skip
> > >>>>>> vm_module_tags_populate() and write to unmapped memory.
> > >>>>>>
> > >>>>>> vmap_pages_range() may have installed some PTEs before failing. A
> > >>>>>> retry to populate the same range would BUG on them, so undo them,
> > >>>>>> but only if vmap actually ran.
> > >>>>>>
> > >>>>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> > >>>>>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
> > >>>>>
> > >>>>> If a patch fixes two other patches, it likely needs to be split so
> > >>>>> that each part fixes one patch only. But read on please. I'm not sure
> > >>>>> if one of the fixes is correct.
> > >>>>>
> > >>>>
> > >>>> Kept them in one patch because they only make sense together.
> > >>>>
> > >>>> After a failed populate the reservation is released and the
> > >>>> size rolled back, so the next load takes the same gap and calls
> > >>>> vm_module_tags_populate() again, and that retry would trip over
> > >>>> the PTEs the failed vmap left behind.
> > >>>>
> > >>>> Without the rollback a load that already passed needs_section_mem()
> > >>>> just reuses the gap, skips populate and writes to unmapped memory.
> > >>>> So splitting them leaves each half broken.
> > >>>
> > >>> Yeah, that's why I think vmap_pages_range() cleanup should be a
> > >>> completely separate patch with vmap_pages_range() doing cleanup
> > >>> itself.
> > >>>
> > >
> > > I think I get where you're coming from now.
> > > Thanks for taking the time to explain.
> > >
> > >>>>
> > >>>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
> > >>>>>> Cc: stable@vger.kernel.org
> > >>>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > >>>>>> ---
> > >>>>>>  mm/alloc_tag.c | 10 ++++++++++
> > >>>>>>  1 file changed, 10 insertions(+)
> > >>>>>>
> > >>>>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > >>>>>> index 2070e682fe10..95ddf5b743d0 100644
> > >>>>>> --- a/mm/alloc_tag.c
> > >>>>>> +++ b/mm/alloc_tag.c
> > >>>>>> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
> > >>>>>>                                      next_page, PAGE_SHIFT) < 0) {
> > >>>>>>                         release_pages_arg arg = { .pages = next_page };
> > >>>>>>
> > >>>>>> +                       /*
> > >>>>>> +                        * vmap_pages_range() only runs once all pages were
> > >>>>>> +                        * allocated, and it may have installed some mappings
> > >>>>>> +                        * before failing. Undo them.
> > >>>>>
> > >>>>> If vmap_pages_range() failed to map the range, why should we need to
> > >>>>> undo it? If it indeed leaves some partial mapping when failing then I
> > >>>>> would argue that vmap_pages_range() should be undoing these partial
> > >>>>> mappings itself before returning the error.
> > >>>>>
> > >>>> Yeah it does - none of the paths under vmap_pages_range() undo themselves on error.
> > >>>
> > >>> Hmm. I wonder if this behavior is intentional or requires a fix. The
> > >>> only possible reason I can think of is performance but I can't imagine
> > >>> a failure to map is a performance-critical case.
> > >>>
> > >>> +David Hildenbrand (Red Hat), +Lorenzo Stoakes (Oracle) what do you
> > >>
> > >> Huh, my gmail thinks you are still at your previous companies :)
> > >>
> > >
> > > I manually fixed it on the mailing list for this thread.
> > >
> > >>> guys think? Shouldn't vmap_pages_range() undo its possible partial
> > >>> mapping when it fails?
> > >>>
> > >>>
> > >>>> pcpu_map_pages does perform cleanup on its own as well. There may be other similar sites.
> > >>>> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/percpu-vm.c#L255
> > >>>> so I did the same here.
> > >>>>
> > >>>> If we really want vmap_pages_range() to handle this cleanup internally, I believe that would
> > >>>> be a relatively large change, and we would need to consider many more cases. So I think we keep
> > >>>> the current behaviour for now.
> > >>>
> > >>> Yeah, I understand it would require a deeper cut but if that's the
> > >>> right way to handle this we might as well do that. Let's see what MM
> > >>> folks think.
> > >>>
> > >
> > > Sounds good to me. Let's wait and hear what the MM folks say.
> > >
> >
> > I just looked into the call sites for __vmap_pages_range.
> > And I found there's a bug in one vmalloc caller [1].
> > When gfp_mask has __GFP_NOFAIL, the code keeps retrying
> > __vmap_pages_range. If there are leftover PTE mappings,
> > this can trigger a BUG(); [2]
> > https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L3946 [1]
> > https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L121  [2]
> 
> I think best person to look at this is Ulad as vmalloc is his baby :)
> 
> Ulad, what do you think?
> 
> Thread is at
> https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/ for
> context.
> 
Uh.. I missed this. Let me check!

--
Uladzislau Rezki

