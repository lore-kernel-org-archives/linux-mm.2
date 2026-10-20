Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F11606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 20:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=FVz0GOKC
Received: by kanga.kvack.org (Postfix)
	id B4CF66B0557; Tue, 20 Oct 2026 16:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE086B0558; Tue, 20 Oct 2026 16:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1446B0559; Tue, 20 Oct 2026 16:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69FFC6B0557
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:20:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAD791203B2
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:20:22 +0000 (UTC)
X-FDA: 85344121884.07.6A25AEB
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 02B651C0003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:20:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FVz0GOKC;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792527621;
	b=rsN3Bsin2higElwyLuGUzrw4ppPVgP/f5qruOBJfJqa66oWQU5UGhbS/V8OvCqHuyfyUFQ
	azpvdzCOR0lXMijyra4xpMTSuus9kR/b2k7obHVAkEH7bWWuCkTYvnGb8w0Ad9GXvnixlP
	Ou0V+p4U17/pyDDyoJMWPH/Z0cEe77s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FVz0GOKC;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792527621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EPIXAJZkQDCcHbLvbKTfW5OnsdsgE9PbSQDDg/rz3K0=;
	b=Z080+uS1b+I2fTi5naVZRAEIjVNxjP9tCaHTUYGsoQlCEj7H/r+srjcOAIayKXB0IW9PyG
	naWXsOq9GfQ/H9dxgTcf3e3wq0zKc7pjLkz9/nkj9HXbhivUmYHN14/KCt4xrfllT2RD8X
	RmL+ick+Lb/cbOXJxMIEHAdmE77NXKE=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93ead211f14so4085385a.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792527620; x=1793132420; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EPIXAJZkQDCcHbLvbKTfW5OnsdsgE9PbSQDDg/rz3K0=;
        b=FVz0GOKC84byVrbyL//wMGD8Pv6vuf0CWMFX/wVgun2O4ln8a6TmRaTGetZPoqdoCO
         jyHPTlXQ8Xjx51NMgwl+q16qupOuYHYEifyA10FY072nO/H3aEkO2ZS4J27XXkGcPH6C
         te1d/PG4RZqMoXaKv3/3CRxPQiXftf9VJ6Z7FwjZ7n6vHJPKKFrvrWxuq/lWGIhskGIX
         R2EvrvWE0TGWdglzlBFPrOjY0MdHKFjhiSwKtrJXB/oPBaISCbHyr1QTDP48C5NihVkm
         6UuYkHsyE07k9Kc8awCkR+XuNVqvGs0i5U1FuegjJ5hzSeKs7Fwwh1uvtq2LeuvcxIuO
         dUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792527620; x=1793132420;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EPIXAJZkQDCcHbLvbKTfW5OnsdsgE9PbSQDDg/rz3K0=;
        b=QaljfovfalKXyKaPlknaizjNL5kgAslIlwPhsIh03+7hbG3wNNdPYqmWfLV64iNohf
         LniOahp9UGcPoZrvuUTcDZ9Y3JWc6T81XAvPnxXhK/MyzJT119o5bExaI/tuAle2txEs
         43I+IJVoxzfn1zy7ahaIl70O0QT4T3D65/wyvpi674KBAHKTiJ7Q6PPjkLKJgeMLfZij
         50tZkV2fFt3ShcrwprnkuIh4bb5Z0OLorglh5eqBnpp7u2KsQASY+m10VCEp0XOtp6DB
         Ujg+MjcmRcPbZLnk5t5loIcV4qtIKK7YHfV8e2VQdAUYeu5pcIADexfB38zgXCrYHN+f
         hZPg==
X-Gm-Message-State: AFq9FYK1u8oGICD8Q4Cn17ohSZ17StRNegSIKlYojFXZtILtJMmp9Oc9
	w4olZsRRONPkf9Poiv9osglX0tFULyD/zNzBaSUCJNtem064kcmxHYcx41clNcYBRQDD92wDyzm
	/q3Vk
X-Gm-Gg: AYBFou1lF9L+2TUIIfYCZk+tAmT+WtPGXu3/iQx4cmT46yM0uH3DyVouv4oJV5jaN/7
	AcZbqibn4VS65D72XFlB2qTrWmpZ/5TqLIbJfeOPC5PmA54k8ppk9RdDbCvFjLnUmDKnZSuwWDO
	FrbPKmN6QIBA8+IF5ZaLZHHJkF0aNqYyVFLReaRyIPphQWJwEnKoH3xBYRy6V+JByk/txiFqCqw
	k4Ng+Vk/vnDeIOEGJ3+czVMjvOAsumZctLEmAJ+QEtAeKGOUq2UnMvfykvGf8OI384O7tVVvr+5
	amfhT6aarPkpTgFe16WrmwlOB5EN7+QuI5wnLg9Z1byUcJfi46BXdfgXHARYoLI9DNb+Pfhf8i1
	k8kY+XQoaFKEIT+yfdYCxn7rWCfmB3U3wn6e0jeSVInpsPE3V5LR++f5SEGBLsr5id+GCP0rjz6
	xC81yPRPtuo/Qgutvfdts7C3i4KjUPRKLo7EGKvKRuM5wYBx9sEVgDsZlqrKg/GxzQf8ZtKEm+e
	ZY9BKGkW9h7lTh/O7dC8m4oSOwowj3hYJRec2/8yWzxfoGki9hcsxHXRtkZBPEf7w==
X-Received: by 2002:a05:620a:44c1:b0:93e:c173:f690 with SMTP id af79cd13be357-93f57fa664amr59174285a.36.1792527620137;
        Tue, 20 Oct 2026 13:20:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e30610sm68153885a.43.2026.10.20.13.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 13:20:19 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:20:17 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, ziy@nvidia.com, mgorman@techsingularity.net, 
	jiang.liu@huawei.com, Bessel.Wang@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/5] mm/page_alloc: validate zonelist slots against
 concurrent rebuilds
Message-ID: <atfLxfuFm-c8pKnP@gourry-fedora-PF4VCD3F>
References: <20261019172346.3344005-1-gourry@gourry.net>
 <20261019172346.3344005-3-gourry@gourry.net>
 <45ef34c7-eea5-4813-b54f-3e34675697b5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ef34c7-eea5-4813-b54f-3e34675697b5@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 02B651C0003
X-Stat-Signature: 7otcjm9f6795wp899o3f4knqyj8ee837
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792527620-494826
X-HE-Meta: U2FsdGVkX1/9yGfeNqaGiVISWgq7HHCvLeUfaDTRPJeWDB0apTP8lxlpTTOQmHNRciAe2YpSWQLtnHQtBTjYgxSk5I9rpYUHPg0fHFKyNLZUEbO2pkU9awhq5WXHOM2KLPH3IawLh12ftupNS9LVENLeGLjwBzTeaX233I7aFeuGOF4qHtgsqMO2rZinVkvfD+dLGPCuTMTDe/Mux2r6qbzUp5RKRU8TrvziJTfxyaLdz38QZrzGqmcjnM8APy/b7CkNJ1aa8tWhnF1ziTFGrnsZPTfTi81/i87RopdnkSY/QY9IkB889xjEEV3LDBhzo/eEIJ/dquuaTxLOlbJ79zfm02YzFZLKwXm1FIGO2Age+W3I8z9ScWzS/xUQafxiJakDBLYFO4OvxfLme/71AstGK2xJ671f90MAY6yydpmoGod+4poNVrKpfiW5Tgy93GB8QikbVQKW3PloUrwX+/J1TGTKTphA983B4vfVv5vKqOAvMvPGKgeHSTtlN4jm/FF3mUuOk9yQmAZrp/qQ1528kIQPXjgymvO+uUL/bIpfiw+A4NKdKI93wyk+MdayEPCsSdBSFyXMqd1EtyWSZPX7aHoQImO23Ap8nRlLJ505csEpKHLhRVIqWyZpInrIsEkj8AfwYIVpfT6ZHXGn3EVOG/huMWTXOklyp8K3gTuMAJJia8/lPwcrGl8ZJea2S7lD4l4c/wv4eiA9iE6kYXuJ2/C6zgqe5ZDqsx6Mzc1V7HLSbyRVuYf/FDZ0AnRmn7mQ8UFczZS00+tQiMJuQ5BUaxa1TGSrkajfpjI3a9/hcZhtX+2znvcmXBj1FfK/oa+TykUeklJy4x6M/fBkwP5LXMSQion1VHoNe1sHbeOBeIsyML8HRxt11dUQWzekZxJwA3B+R53JdTpDjlxMW+j62XRT/Kn2Gs6yij7NBCuDMZdr4diXGLNZVe0z4MRWnxrtKyXx1lnQjEpcq2Z
 ad2QcgV8
 WtnaVcfNVBE4nWYr9QN4US7DZD4K4hyEt0lYomuAyrqRZ3KWaarMV9nVAMyx4zAYiAnWL2ySZQKxM8/iJE7nGyvxrfqYkvhz5b+YA40wecy60TBwxuMRWLzJ/Eb2tF0TA4CFkb+TdrABTPAMxNIZnK98BCLUBOszGlDy4ZHjyr8Jkjh7PNvFGMybJ+3+DFqRkCGfnjvguFiqnPKxh3NDaETdax3jupzmq4klBuT8/tCV6cj9JxK0LHS5CkGvsKnuCLlhVC6TNxzzT7d6nf3pVz2NbvV7SNIRhpP9IU6dss5Vl9rtjPhy6/qJnKVW+HvS4EJgjc1C3ibHlDzDh3j7jTyGM0zbsY4HBU8K/EUXkL16GsWgIVk7R3ZvronUGbqIylbljKk2akWgoWIQwhB3BQ5q5t7t/un49dWbhE1wwWSfillTmrX3NlWR3eDUSAwL2kaD45Sz/6W+iYpI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 05:22:11PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/19/26 19:23, Gregory Price (Meta) wrote:
> > Onlining the first block of a zone rebuilds every zonelist in place,
> > shifting the slots after the new zone. An in-flight walk can use a
> > zone it previously filtered. e.g.:
> >   - a GFP_KERNEL request can land in ZONE_MOVABLE,
> >   - a node not in the nodemask can have its zones selected.
> > 
> > With kprobes holding the walk across the online, I was able to get this
> > zone/node misplacement to happen consistently across hotplug events.
> > 
> > The iterator approves a slot by its zone index and node, and the
> > allocator then loads the zone pointer from the slot again:
> > 
> >   CPU 0                             CPU 1
> >   first_zones_zonelist(nodemask {1})
> >     slot 0 (NORMAL1) approved
> >                                     online_pages()
> >                                       build_all_zonelists()
> >                                         [NORMAL1, NORMAL2, ...]
> >                                         -> [MOVABLE1, NORMAL1, ...]
> >   get_page_from_freelist()
> >     zone = zonelist_zone(slot 0)    /* MOVABLE1 */
> 
> Since the zonelist_zone_valid() checks you're adding happen before the
> "zone = zonelist_zone(slot 0)" part, I don't understand how they can be
> helping here. Aren't we just reapproving slot 0 when CPU 1 can mess it up
> between that reapproval and load? Am I missing something?
>

Heh, see patch 3.

patch 2 and 3 should probably be re-ordered, or maybe just squashed
together?

~Gregory

