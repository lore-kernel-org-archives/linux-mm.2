Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA428CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 22:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77606B0005; Wed, 10 Jun 2026 18:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28D26B0088; Wed, 10 Jun 2026 18:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EA56B008C; Wed, 10 Jun 2026 18:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1A736B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:27:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42C6EC1767
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:27:17 +0000 (UTC)
X-FDA: 84865440114.22.1F2D470
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C9FB4000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:27:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NxciLMhL;
	spf=pass (imf11.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781130435;
	b=tsMwCAuk40Ndmd8JcS1b5Rz8alZio5B7pEd69HFzlCvVQ38HVaMM5u4cvx6zaluwpsIR7p
	8VyZFX2rUJif3co/2GvWStnmnCxNZaf95A3wBTLfUUZ61ho5ICApuX1540z3ajsKj2jf4W
	9du/jy12Nxci/yoWlYaIDmR6goyRACE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NxciLMhL;
	spf=pass (imf11.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781130435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERJnitgYeN+oHp0QIhM2Gx0sT2CNtRoOhhriDExY+yw=;
	b=Cmz7V6P0+6XbfPPIEfRLAlhjEk1GOaPm1VNhlq1R20nBrRuAjTAm9JAfyakQIgxc22YQxW
	TtvrcAJII/a0DEJp1zCXb5+9tFVMqVWo9UkQZiLmbV+Y5aydUBC6azBeiG/03/2srFq0sJ
	tV62oS4sX2hyS8pugN0+r+BOfjLtaJ0=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45ef5146b56so212757f8f.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781130434; x=1781735234; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ERJnitgYeN+oHp0QIhM2Gx0sT2CNtRoOhhriDExY+yw=;
        b=NxciLMhL9c9Mzqppu08zRZ5HLv2L3s3nW3eo8jLjJ4XbJBPrPtPke4bNB1QsJcMvGm
         XcthPEPOS81wv7lKkE2zs3qSZgKKWsqUuORkVGWGiOBxKjmdSquIqMeTheIqjA6rRLO2
         fUDNGChE1NIPLhF75nJfb09mzocrjsfzfEt/vO+qZmzxvW2BzO0MsDLG2TC9rLT/vv6F
         iYMRqbeRImzzQ4JpxC//J6j/bVnSFnDcbszKnNqVcA6DhCPBc1c2XY5dGHD6mNPMv2p9
         nfcS0OJsEVildwbF0O+hbujStFZZDYcRkapBaxynXFoYUWSN4UQbWwgS4q/dcosAGeLX
         kRNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781130434; x=1781735234;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ERJnitgYeN+oHp0QIhM2Gx0sT2CNtRoOhhriDExY+yw=;
        b=VjfQx+RADcwruhooCeBT1adR3gqFe6oZS+l0EmvLLMBCM4Wbd2UmtheIWLlQzKRiZy
         wilb7xjbfWapVa47W6jRRhsK/tB7DJjDKmyNpN0CVXFw7sXFghPU7vJS+jda8eAonQq4
         yPdLiog2d+989jlje74CoFm/HXZ/+u0YoW9Q1lF1oz7tZBJJF0avCvxgYm+Gxz5YNsfa
         H23mWo82Z8JK5GWVTrRiwqi0/bbCQn+f5g633tDNpDaedMH8WW9qgeIGvFw547XcimWe
         py3vig5aSr9KjBAA/rcQnFOf/tBM1jftwXGYo1WUY34uOtcUnqfgvCAsHRw+FOxuJYLE
         WxlA==
X-Forwarded-Encrypted: i=1; AFNElJ8pac9/Xo9lad+0B7orDHWbLegh86fKlkPzaZ/C0/CO2uGfULcx5aJBZWqV56ZNE7XbJHuf1CzyTg==@kvack.org
X-Gm-Message-State: AOJu0Yyw6XOjm3OnWaNr3mf3bGpON4DAGztc+XB9jtFpg/vSYkA1aCHy
	DiOA0fXfPFCoGXokaOYr9P5kSM+sVXMEyV4jSl4zJOTJw8IlPWBwwauL
X-Gm-Gg: Acq92OGxvFdrHHdn3fThBQjxnrIwZCD75cdU/I0UIQlxTmn+/8nvCgnTlgwhc702mW/
	rK6AuSp+j2LFDQLsGmEUqLO/rVm1Gd0aVMrm9NF8eV2Vw9tBd74ZshAj7CGmhz95oT9HLcUf47h
	MnqVokMXaJ0RssWeaIDkVbT0G6qHxs+idE4I3pKjkz7WKoAsKc3AJ7pGs+yY3LECguT/cY9x+CI
	MQulGHdLKLOl5EkpsyS1GaKhQ0XZkxnRprVM6ycteLFdpoIb0OZNPs8az0CWzA9IHSMVG/nQyIy
	nOqDMnj3pi+RRoa+2L5iVvwgnBzvri1P5yCZMn3yL3NQ1DaxHo+aog4eAl+m5C3S1J0v7Xsm2Cg
	p/5sMcI+ytZP9/T4Wtrsy7LDkKC85CczCO98rWHDr0Ru9YR9W9MT2QCF2IKjLxSvH8lA37BdfYG
	TgZZkciUl2lqqrAjmL9DDtS5vkPaotKoIrC0GBjg1TJtLHmZ/PBdLNzgHfDVrhtKrY2LJ1N9ohf
	TpxSgNeRc5UOk68JZBEJupt3tJeDavF34dAeNUuEbAH2Q==
X-Received: by 2002:a05:6000:461a:b0:460:d18:865c with SMTP id ffacd0b85a97d-460664c54bbmr512993f8f.1.1781130433530;
        Wed, 10 Jun 2026 15:27:13 -0700 (PDT)
Received: from localhost (pat-125-253.wlan.net.ed.ac.uk. [192.41.125.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcae2sm80574537f8f.6.2026.06.10.15.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 15:27:12 -0700 (PDT)
Date: Wed, 10 Jun 2026 23:27:12 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] Memory fragmentation with large block sizes
Message-ID: <20260610222712.cmbforeivf7h544y@wrangler>
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
X-Rspamd-Queue-Id: 4C9FB4000A
X-Stat-Signature: fbjgpunqbnutexzha3y3cypo4k5ttzjn
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781130435-821190
X-HE-Meta: U2FsdGVkX195uqXmbojbk1e5OPfCRM7y5Atd6Ji2/ygpApmRER2wF1wmAwdPrjycMs4dWkY+LJgTLFoRMZd/JmkYZ54qTdZgtGKiUZ/UE4ULiShZa9L+6BesQdxggq8KInlktTdBx7c2lfoZ9Z20niDypnTn9OEOXKlFBuE+3SzdJkpMFM7kJyi8p7N8yt2QdkVhUdkhkgAcr70GmU8eHVGdN/bBSs2Os0qbqHB7nzrspd2/e0/BNyuxVIDPdWybpA5e0v2K4mJlBSRkvqkDbVJ7WHFEGijIUKvFC7zf7smLv7qXlOBGvyWVkE8DglT4Snp+hAyKxePjBdmT6/7vt/ceBK21w9/czVX6EfZkUj4+mwtn4rsFfXKj6KC+3LAbKdGYZZMQxFtXw6tPnbY9VaAtXxvM/Aaogff2uiYZSb5E+uJ/MThmQhJRk+oYON7Qd9KJO0q29k9LP6JNL/pWyYRdO7e3z1O2UTOMvqpFUxwtPlC557VNFPrfvRqe099kp4j3cV6/DC94yOy9xBDb/9Mu7szbPQcHyvqL9G9uYagqUAhSQNLtcv5qB9QccTvk2dmnnnktv3BPrL4Q1bmXtsF3tPgUARpJGvdhmPmuKyEbu2nlt0DuqmHpr7NWlx06O78nwc1iLoV1nvxAgha2UU4V0GMfKmHTbTgAY7LDEqyMLAi+RhdjkKVg49K17BPl3oAyUaZrVIsBdR+OhwIycwCDZoKi7hdoe0QL9aeHFDJz3QFHfiGoOdgxDoS2A8NWZ1vteQOmQsX7Q9vaDg7T+pw9v+EnQ1kBnJWv4Yr4tbqEVUN8kJEQj1ipsAFGx++E5rbTIx4goIRFN4S7XPXsC2gCdzWtqqWTTb2adoQfnIzSYd9HVtYqjdBo2/Bn04hGgWAPoycHVve6vzySiAmjCU9kgiOubWDP4yl/D4qt7v9bTCxraZhSnkmVOx/VOaIfBlOsmim5+W37Hc09cSB
 xJjaqLM1
 EPN3itcSP2ZpEyL7LeSppfa2cK9IMy99JqZioZ3GUDLqnxoLaqFb06QL5+U4/xfdpEyXOSTt5CGFeTu3O8FZVDkFVTU6mrZZ4A6NL7m5xnkawW/sgquWcSkmeAgErWml6dDSCCFyUDqKNV8othJWbIdbttWNhX0zFqjAgxj5eKD0/7tYVyGmjOmUXvMXCAsfam1JZ43gfHLHqPFzleRwDPtMv0PwbTVuKGC/VFThSp6l/lVHVnD/RhQb1Yq2i7ne9rSvfhqKUn7gch8uGjQPYXYrQ0lHzk8pwPtnfM9IFRn7Jxo77i3djoT60mJVuCsiSaB5vMjoz8gJK5tXpud/+eWloqNmT6/zaQIq4bE3hqCAOuEhyX7e+q7DXIyHc4MmhE8MSa5ZjbEz2zRjytangdwpvj2LtHYhmz/T3SAKWxjxB9cXc+jQZXjqdXPh7y1vXhnHHsbxaj9FtFNNWS2f36j34tnFFRsZs4epKlo1Apd13XVjuhwB9KoogMW9g1yA/xlggdHN98vHxDx1Gb2/s4NAPgtXbF6erJKEw4lN1CGdO9kmGj4t5qkh1mnYcw7mGTdGCdChi5hOrUEO9GQYZKywceiJfVQbz/LFNiPlBhvTgVmGjh1YayyCds4VCMGI/nRgG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 10:54:48AM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> I (together with the Czech Technical University) did some experiments trying
> to measure memory fragmentation with large block sizes.
> Testbed used was an nvme setup talking to a nvmet storage over
> the network.
> 
> Doing so raised some challenges:
> 
> - How do you _generate_ memory fragmentation? The MM subsystem is
>   precisely geared up to avoid it, so you would need to come up
>   with some idea how to defeat it. With the help from Willy I managed
>   to come up with something, but I really would like to discuss
>   what would be the best option here.

thpchallenge from mmtests has been a staple for the compaction/anti
fragmentation folks.

And check this https://patchwork.freedesktop.org/patch/716404/?series=164353&rev=1

Btw, do you mind sharing what workloads you discussed with Matthew?

> - What is acceptable memory fragmentation? Are we good enough if the
>   measured fragmentation does not grow during the test runs?
> - Do we have better visibility into memory fragmentation other than
>   just reading /proc/buddyinfo?
> 
> And, of course, I would like to present (and discuss) the results
> of the testruns done on 4k, 8k, and 16k blocksizes.
> 
> Not sure if this should be a storage or MM topic; I'll let the
> lsf-pc decide.
> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
> 

-- 
~karim

