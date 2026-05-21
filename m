Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A21CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 23:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518186B0096; Thu, 21 May 2026 19:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9236B0098; Thu, 21 May 2026 19:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405EE6B0099; Thu, 21 May 2026 19:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E49E6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:31:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C65E5C2A2C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:31:13 +0000 (UTC)
X-FDA: 84793025226.23.BE381DD
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id E5864C0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:31:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QQLK3Fo+;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779406271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DnVBY/gIrvG9PTA5e+cvuIrP5NR07Enj/HmhXB9HoTY=;
	b=LfqoC3xrZktEPVuj3jk322+9/qBjffELXr/6/Lb/KwAqIaqgh3vP8SAixkuC8vHWU1XBzk
	WPCHS1cuDwoOCs76YluBnL0tVCnaB7fT7S7YOlE9G0ASOahspCNClcb2rxP3S1LTj8Dk4o
	jRc8LEn4CCAtmJmZvl9uImhZtzio9SQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QQLK3Fo+;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779406271; a=rsa-sha256;
	cv=none;
	b=bvkCQG/SBVc3e9C3N/Iw6JhoK+0U4RFRpMVTYQbfeuS1ecGgjVEi61TgRL3vTntA8FpydH
	MWy3uQygjaHOPwlXcueJLtjYtpFUjxYn5lrxP80dRjJGfwKT7N7kOIY4O3RWyhBbHQEHrE
	76KZ2fdtPSx0GRy5Zi7vAxgN7TuTnVA=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9102e90bcbeso735248285a.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 16:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779406271; x=1780011071; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DnVBY/gIrvG9PTA5e+cvuIrP5NR07Enj/HmhXB9HoTY=;
        b=QQLK3Fo+8T8f3A1+q6qrZvrJNXDkdD8c336KIu40k/cIdi/mBX8LCtDMClGGqHs1t4
         Q0hAWJSBAUTW78x5ffr1A8c7JOWIkhlP3BVEHghbS9p9nXH3582B6Mx52PTJ1KOsSbAC
         LJiyGOdTeWZ7AEpvC6e20DoonWMvspts35w88MqJLoNRwTIng89gszRrLYLe14PGD8Qo
         6ug6YaIzMy2rqqk8TH+myDgYqV1J8BUIpMI76F4PtfX4TtFSmkjkP4Y7bjRk6U4oA/UI
         lIYhp1eNvrlqkUI6UUfPHS2lD2Jd2oMDb4c2YCnLD8Z8rkNxtkkWIvPz059mjmkN61Ku
         CFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779406271; x=1780011071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DnVBY/gIrvG9PTA5e+cvuIrP5NR07Enj/HmhXB9HoTY=;
        b=o3BwXwMMyueO/8f/F3VlX8oXrEsaelTj/JtKjHfpP4zkJt2/1HyE67EMpTCggs4JrO
         5rZnlf6GJbc2XU1AkZY9KxnlUHsj+vhkUwqGLFzN9JITc4FJxoNIpocKyLH6OTEK0nYV
         y3SloLvS6By3xfRyVU5oPL/rWnWoKY4FWmjSUBHYso+BwchScUJrRtmood9r7fbhZHH9
         s3BGBBzmTGLhl2geR1XHffDusacijyLkHaLuEIb15U7ETyw45Mrfh5Y5SDfBNt+iLHs5
         j5ldmBfSVtnQHRwywK0DrQIMOcfKMI+n9emHy/Z7JwG/P5Lpn54kviI/n4Chg8vVj/Y+
         56QA==
X-Forwarded-Encrypted: i=1; AFNElJ8K2AuimPvOE1uIOuM0t2Ancj9zEjmBQVKpPB9Ezui/Tbg+fiNmgsjrTXjyAgnEnMequouNco/iwQ==@kvack.org
X-Gm-Message-State: AOJu0YzNzQAbOQ9s3E46LUWgR7Dd7T+Mm2z+f9QuaFQHMcOpsoMIPlhp
	OWCns2NIlWdzxWF7jOdC1h9ilfJjS+cMPECfh4+qtdqR2s0nV0ZYCy/4svXaEAR6PCc=
X-Gm-Gg: Acq92OFxiJUzcftVzAqafdzbUnoy98cpgQ4+ExvzOonufygZwJ+U2PFfwE7B35hwdXr
	N/sNQEu9TLD5yRQR4hrzqLgX4vPZHzcEFH1IuklTJLQBazZWbEhl2iNItsYiccAf0GBkIa0kpmw
	4eyJ/1EDxJge+smqXxSm1C+6G44pG8DX3Bs0rky/0ZJOAkAoqTc/Dcwp6H535GBEIeob1E7GuqK
	jy/kzJgJCfn05cjUWZvYQZdOQBE6mrD3aZ60DUZOtss1yqTAA+Iu+bSafC3LLrzI0jGv/xUJISc
	4zUftYYIOKJxiF1209ZKBu+MSOQTA9Cx4Zr2ax/8P8hRpkodcF/tZE6TdlrUKnXSdKpXDMgtnjp
	VhVz7KlKLEM/BV9gK67KdWcITTM51gjKuwgow39ewGq/m/GXvL7q8t/dfcnWN4h0WH2vV9WcOzr
	13o6A5OZOG19VO+0JB0TTL8ApuvDleeTgRkkWqbkWV/6iD67ETW8qWsuHoiX/Ang==
X-Received: by 2002:a05:620a:8393:b0:8cf:c0c9:bca with SMTP id af79cd13be357-914b492cebemr215182885a.17.1779406270986;
        Thu, 21 May 2026 16:31:10 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914b604e040sm34931385a.45.2026.05.21.16.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 16:31:10 -0700 (PDT)
Date: Thu, 21 May 2026 23:31:09 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] kho: add a struct for radix callbacks
Message-ID: <ag-VfUr_XuxDuHS8@plex>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-4-pratyush@kernel.org>
 <agHB7HB-p_vkLS7R@kernel.org>
 <2vxzzf25c39x.fsf@kernel.org>
 <agLNUKE5LZqcoUex@kernel.org>
 <2vxz5x4tat6w.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz5x4tat6w.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5864C0007
X-Stat-Signature: oij4kb1qf1jren9d46iph36k139ciwyk
X-HE-Tag: 1779406271-72714
X-HE-Meta: U2FsdGVkX182c9wteMMiumsizQiBDnlsut/vOZEIyVwvXI7eEh2BuVPFWsCyXT8MaQsoFoV5/snybqfs07EawXqZSShg81zTPE777UV0lxCRLK0Ibhtu5zX7ozCRANbUQGPYM6cPURpDLuncTcDvBXtA+WbyTQDSVs1yP34JhRopKajBlR3BDblhOH3+iFUZ6/JAd+WfvBwFVDWbW68aBMVDda1byw05ikTy6rVlKmugjmeajaPNvsRYTBjczKGN9q9t3tKjLaezxAct7aaLoV4HLoWv8r0/zMCiLXLaH3hN8dYX4cblvBkqOvOxn0eiC93z5tqO1v1eufnWngXayLLK1SX6ABtvpQH4Km856Yi2bw2GEbxI9/ZVxG+WJIDv2+J1a58agtHJ5ZFJ20gtACWaekFFOnBgczn1huueGbUlbdFipdQJB6Jed+Cl0L7WkociTdAEcHCb8+ee0QSixzHMs8tG1mZQ42eNusDINEMCWzjl5eKdb++xkzs9By/f9v91aLxl1Gd/bdihB9WK4sVwk+bdCbeNgTTqxMzg+/bT1l1OyEuQU+6LcJRNeouCUoi+jBfSj4Y2+QpTKwR7xg0E/fXU9bFW/kzlWYheHLZUA/KO160FBQg5oJakgXs3PVsL8rCe0WV/sTuCfyphsFWL0+ZN9Q5auryxIHiVpACMnMDZqmPalhOTH1KAMZgMtVx0iyPw3VarVGTHa5g95+EM0BGyZcpuPNngqYUUb15YW7R0lJZFFMgKHSGNmzDRBfXZTOEu4F1P/AeP27PLxnUHtszxofAYhVUbcSC0uSGv0GUpl7JP39aZDe5GF88Agd3KcrPv+cRMKAXMBbcu4j0sQ/iiF65YnLLzQrGPlSQCJxLT58/2aHyS9zPYcPL0J2Cmbu8Yrzz7VSXprNIgjBsPUhxQQfSWtFLxK1kGd4YjHmScyAvRiqSaOa/SPB5/RsB8OrSLwHNy1CKxzyp
 yQM3Vndi
 GTF8l3i70scf9IySxAJm5xZBh99zKDGJ+4WsWqnrtQSuKaOsWBUNFctYu10qBIRxljp3aPJITtdSbM/X6kbj2hyeExZ+XlaPj579oEes5SQNxIbH45uJaG6M3aRjzkQPbaES0HLT5z102ROAYTqY6LupJOeWzeT8p4FtcHnw/6ewRODxHnAeKCi2zzPockTTJ3ZadeBeUoUOz1JAscaYH6llIY3OBgk9By6iV0KaB7Ae20VnzoFUx0Pbc1QYp5f416zRd0heBcKZSlwzxboKd0Ze2yn7igXtOkc8+FuBXbt5TOgHzRRn1Ola2YVBavNCb6WjfQNVA3Nwf2ODHpY778xWjQE+L3oa2nWymC/Ty9LZTv4DtKeKCR8X0XRTSvvbIXpre7P35E7LqvWmSwG1wHWrJoqr89Hm+5ymHfP6cb5B0JSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-12 11:11, Pratyush Yadav wrote:
> On Tue, May 12 2026, Mike Rapoport wrote:
> 
> > On Mon, May 11, 2026 at 06:35:54PM +0200, Pratyush Yadav wrote:
> >> On Mon, May 11 2026, Mike Rapoport wrote:
> >> 
> >> > On Wed, Apr 29, 2026 at 03:39:05PM +0200, Pratyush Yadav wrote:
> >> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >> >> 
> >> >> A future commit will add more callbacks for the KHO radix tree. Add a
> >> >> struct for collecting the callbacks.
> >> >> 
> >> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> >> >> ---
> >> [...]
> >> >> --- a/kernel/liveupdate/kexec_handover.c
> >> >> +++ b/kernel/liveupdate/kexec_handover.c
> >> >> @@ -266,16 +266,18 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
> >> >>  }
> >> >>  EXPORT_SYMBOL_GPL(kho_radix_del_key);
> >> >>  
> >> >> -static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
> >> >> -			       unsigned long key,
> >> >> -			       kho_radix_tree_walk_callback_t cb)
> >> >> +static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
> >> >> +			       const struct kho_radix_walk_cb *cb)
> >> >>  {
> >> >>  	unsigned long *bitmap = (unsigned long *)leaf;
> >> >>  	unsigned int i;
> >> >>  	int err;
> >> >>  
> >> >> +	if (!cb->key)
> >> >> +		return 0;
> >> >> +
> >> >>  	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
> >> >> -		err = cb(key | i);
> >> >> +		err = cb->key(key | i);
> >> >
> >> > key(key) reads weird :)
> >> > Can't say I have a good name, maybe key_action()?
> >> 
> >> I thought the context of it being under a callback struct would make it
> >> more obvious. I don't like key_action() much better TBH, but I don't
> >> have a strong opinion. Perhaps Pasha can suggest a 3rd option and we
> >> pick on randomly ;-)
> >
> > Another option I thought is to call them ->leaf() and ->node().
> 
> This one sounds nice. Will use it in v2.

Thank you. I also prefer ->leaf() and ->node(); they are simple and 
applicable to any tree.

> 
> -- 
> Regards,
> Pratyush Yadav

