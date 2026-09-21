Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48CAC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EEB76B00B9; Mon, 21 Sep 2026 12:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E6D6B00C2; Mon, 21 Sep 2026 12:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D596B00C7; Mon, 21 Sep 2026 12:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8EE6B00B9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:39:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5BE2160257
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:39:07 +0000 (UTC)
X-FDA: 85238329134.04.9936ECC
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf17.hostedemail.com (Postfix) with ESMTP id EC26A40003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:39:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=S8rH8iH0;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790008746;
	b=x11iAYsuMz/sX47E9mHCa9FKDNIPt29/U3cIhIv79vWSaCmNt2eBcCS3QvdAWKxnxfGUWk
	V6XfoQ4JnGITp+NkJsQC1QLnRW/pvXHQ7bx1UGijgmIjfJ51Uy+6W3AfOk1XprnieVICmT
	YJq2aH8U1FToKyK3eSiKiLVT8dJEDVc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=S8rH8iH0;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790008746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHNYxc4ofRbSyKf1aiBAvHcEXeXrXDYKaCYPOfwKjFU=;
	b=ZLJHZV1XWaVfliyRppL+ZE5UGGOKB+bNT3RhEQK1tP9GVg6DN6E4WLWNjwAf6mzOj3AWz6
	GweYx56PX/dmhdNNqpXNmyXQPSg50hSRDFdY5q5oBrgoHAhOHP3POfrcM/Zkgy9UGv3E+L
	cHoPr4HsPBdD1EwfTMmu6/DwjEiX8Qg=
Received: by mail-qk2-f42.google.com with SMTP id af79cd13be357-93bd580489dso334836185a.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790008745; x=1790613545; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jHNYxc4ofRbSyKf1aiBAvHcEXeXrXDYKaCYPOfwKjFU=;
        b=S8rH8iH0UDmKYSX+BewmV5vsQkPbbkZCUaD5wiRyUmZjvGFzBllY1Bp83F42LhJNiy
         GF11ia1n7cKkAMplpk146j4J92F8ldZnmjZ9waw7JCbuIxJVBrec8++k8MLkmYou+AY4
         6XjcjkzWRHY+/iWIQ3P94mkXnrum7LppH0laMhDtGpjc4Uw3S3tgMSP7+TvDoQcU8rJ4
         vooUv++Eb3ip6JjaH5YF3OUGbr0HZrRrQTpZd2VbdEvbxCtJWP2eXTcF920UXljE164L
         N8q0zK5YLEoiBZ2dIoqFxkie1P6yS6fKy+djFutX/8HUN5KitJfSlsXEKN6aXkI/AENO
         ZDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790008745; x=1790613545;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jHNYxc4ofRbSyKf1aiBAvHcEXeXrXDYKaCYPOfwKjFU=;
        b=0/UYIUEbJj94AswVgKqLjPBIa8nv9J666/+tkmumCyvpiVaqg9Xw8g3gqGG5K0Ft5+
         OPBZtBWkUTP4J7dCYImpuf7Nl+SDNrtduaRTKCTntY9/bHVyvXNPwsxWVUQOy6RWhxC/
         3osvC8DbLFaQzl1/sUMBAG471qPYNPd/tRrFK9+wr3aqp+qiRoK3+sUYE8si0SQUEAkn
         QFF92QKTNxPm+3zjxzQslNoGwFTGlfdF4EWnDjIosAVa/Edg0sZcNpajw0Rjeg1peNfe
         bUfu5Mxvn6QDr2UsjipX4o5KYJwwSrhATlr4Gebs6Ymkz2SSkgk0Pm4eFhIGQpCYbnTd
         +t6g==
X-Gm-Message-State: AFuF++nLHiS0ABx2fI6fkxp2r4aMP/ahru24s0C6AfNfcDlfmmKdIvSE
	JeKrjXBhygFhKfutMEA/fwYRLL2wNkZKN0q90TsBFmF/K4hI0DDcM3aQ0p9zPr1ejp4=
X-Gm-Gg: AYBFou3kR9cPYVW2x/+XEHN1E8r6iG2nlWX0+tjUnku7dh8TQ702wVWGklL5F9kcyXm
	jxwyjkbWMz1kPDk6khizuiWthHBLFBp4nxkqxJNQ8cYv9KTS4FeObPqKOwIV5xjoNnkRSV8oY/d
	JxQ5WWOFCcXSieNG5j2KnEoh2ovMvChbgQBo4QbEwaT5OnI2GKfEKNuHEa7ZVzjp6B5BZm+1X8t
	lK2q8SUL5dNZ84hPJ/bAh1FbCHqHycdKsiJBK50RIhGxPsmr/WASa13tdPIwr5yIO9KRdS1aVV0
	wn1OneDiMD9jrGzw4fKdyzpe5wlLnPZnuuvq/QZhzieC2XBbN2WFiEA18xYudAcLhnAOD/bYSsG
	1PKmz2NFuBUAPIAh6qEfazm5ll5AELweXmj4jBnRqdQyBCNz8n2+DfAuyY9k48dXmADWJhfc9ZW
	5WPSeFUpzYyH2FhSFjYIJdm3IHD/lBjtU/eCzoDiN06pUX7tgEaZXcrxFsGCH/MPC7MaosyYK82
	KaxnUqfzNAiMdFs3+77ZIU=
X-Received: by 2002:a05:620a:46a1:b0:93b:d7a2:83d4 with SMTP id af79cd13be357-93c15f2ea2emr125179885a.67.1790008744843;
        Mon, 21 Sep 2026 09:39:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([152.186.177.174])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93befd5c2d0sm675442385a.4.2026.09.21.09.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 09:39:04 -0700 (PDT)
Date: Mon, 21 Sep 2026 12:38:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist() out
 of build_zonelists()
Message-ID: <arFaiV9iVgxIsZ1g@gourry-fedora-PF4VCD3F>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
 <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
 <arCeH_aD5PUM1tNE@gourry-fedora-PF4VCD3F>
 <C7A2977A-CDD8-4EEF-9448-A130411878B6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C7A2977A-CDD8-4EEF-9448-A130411878B6@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC26A40003
X-Stat-Signature: jpxybxha9hk3nii6kddtgqt7yhfu119n
X-Rspam-User: 
X-HE-Tag: 1790008745-405411
X-HE-Meta: U2FsdGVkX184DGnqSk5PdidM2IhPQG+Rcw5W6H5iTtwm9OB6dzVErhpLFJERLDibyjHVBvUi08Ua2vO6C2N4DnhBq1Mw9yuZcdx1NVgBWLPd/IFQqwHoyRqh78WmEb0yR+6y3MFlypSktlmDL4zqEpnmMUDeVo8sJIptWhrRNR7DXnsFlfsKnwV0VDJt4MG787X3gAWyzMBAOf7RraQI106e6y2H5ogzu7qTbr9aw0RHxfBrj+0c/BhDPjswTfp78RUdPjYNc5mp6F5tVj69tEfTs4E3W5B3Ttr7RKLIaSgkXYf95nEYg+oJsM1H6BxB+/sHkcD0EnF6TBBOE2ZHqeslOwiEi5ixli9Xu6rIJ+zdxsvHhiMlMRr8YxBS+0RjerrcY8Xe6/X/IjGszJRSbEBJbIyuEiCAeLzN1JJ9oky3lKy9MHqEv307zd/fvJsLzUxw0Q4/BZuM8tISpMGBwbBoeC2YF0gjdlKh0/jPxCDiI6oZuK5k2jMLyFvzTX9Cz2+fNbI+kRdDhaq+yk/HHI16P8LUbJS1zqRQCldwF0ZVuhkXf/hVTQwalGKb3ANUXeUQFjQUrj6BmbCBqWWZpwG9BBQExtPNkFJMfNLp7xizNa9Zo88w+Q6b7QMN5PQzr62yCgIfbaYh2mI3ljHlO42CK7RTpMYa7FHt7ZiJ75JInrrenKnygtvsYokT2tk2073yQFoerV7278GaGr9XcHJX0X4jHNO4HvHzGBYxMktnyH32UrskkRYQY9vuaZCcL7v45YeGLx1vn8opuWC5xq/5G97MQ1KsLjhE4JbTGGtvCOMqa+qmPcRO9rQblh9ceRGJm9P3PLhgro/OLg/KaKpbx7kaRqbGEuJoRfv0HVMhHuKAUCl66QbKDb5cUymGzrqEUbGW9bQ5p2PoiSHlci5b2bSYvuFrNVZwZVlztk3FKRFmBZqPa+olIHIoyTe1Oxs3YIAKe7IS5CGpAzL
 R4gkDrBx
 Q9yLrKX7fn5aNw/sogOxTk5e8AZSuH+/CbFCW/k4XqTn4Km6DpUMIPa0IQtHmm0+uPu7bg8pHQZG0muOEzWhfQtdI4CW2Cyznw19eqxqV9cpTPJsJoo7kMKohTEUNpX/vmsTWmVPRiNL7qnaB3DfqvAq6YiJMZ+uMCQZZSHAFUFtFGlOcYqcxm3p6aLiQh98Rhzn6pzS5zFXWm5LwIl2dC40RqnIdSpn49k/zQsjeuNNPzMXHockamnIGBoAJMgqQUXXqvl84un3pPjMxVlAB3lmiMS2OaVRGAcdkyRYa097O0F5rtEikiaM1d+tkjz/EshX9/6kNMaICE96aM5gLrG0NT7I05YZMItkIctk9n3iBzq5jtPIjsTDhvZ4ARDMy58r0soi+aR2USsHKcCuD7g5A3309yXhfw6Kc913MZUTR5WiT8YVcaDOmL3tQcIvd+htv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:18:12PM -0400, Zi Yan wrote:
> On 20 Sep 2026, at 23:29, Gregory Price wrote:
> 
> OK, ZONELIST_PRIVATE and ZONELIST_KTEST are not upstream yet, right?
> In theory, the new zlidx can be added when you add new ZONELIST_ types.
> 
> I am OK with adding it now, but you could mention this change in
> the commit message to avoid confusion. Something like,
> for bulid_node_zonelist(), use ZONELIST_FALLBACK explicitly.
>
...
> > And add a BUILD_ON_BUG/ASSERT that forces any CONFIG_NUMA to have
> > balanced zonelist additions.
> 
> Got it. Thank you for the explanation. Are all combinations of
> {ZONELIST_FALLBACK, ZONELIST_PRIVATE, ZONELIST_KTEST} x
> {N_MEMORY_GENERAL, N_MEMORY, /* private only */} allowed?

Slight inaccuracy on the way zonelists are actually built.

Every node has a list in every zonelist.  The contents of each node's
list in that zonelist are limited to the candidate nodemask.

So consider the following nodes:  N0, N1, P2   (N=normal, P=private)

With the following candidate mappings:
   FALLBACK = N_MEMORY_GENERAL  (_COMMON)  (all normal nodes)
   PRIVATE  = N_MEMORY                     (all nodes)
   KTEST    = N_MEMORY & !N_MEMORY_GENERAL (only private nodes)

FALLBACK
  0  :  [0,1]
  1  :  [1,0]
  2  :  [0,1]  <- private node's fallback list is normal nodes

NOFALLBACK
  0  :  [0]
  1  :  [1]
  2  :  [2]

PRIVATE          Accessible via ALLOC_PRIVATE_ZONELIST
  0  :  [0,1,2]
  1  :  [1,0,2]
  2  :  [2,0,1]

PRIVATE_NOFALLBACK
  0  :  [0]
  1  :  [1]
  2  :  [2]

KTEST             Not accessible via any flag, completely isolated
  0  :  [2]
  1  :  [2]
  2  :  [2]

KTEST_NOFALLBACK  Not accessible via any flag, completely isolated
  0  :  []
  1  :  []
  2  :  [2]

I haven't posted the ktest series yet, but it's how i've made the page
allocator ktest-able.  Ktest is empowered to set the fallback list
directly rather than requiring a flag - not something any in-tree caller
can do - which lets it limit allocations to a private node and makes
mutations on the pgdat for that node deterministic from test-to-test.

Works on UML too, so testing is very fast. :]

Apologies for the added complexity in the explanation, but I figure it's
worth spelling out.

> Any enforcement if not? This is more related your “private node” series,
> instead of this patchset.
>

These zonelists aren't something we're going to allocate dynamically,
the enforcement is encoded in the function (build ZONELIST_X over
candidates N_MEMORY_Y).

> >
> > But I don't think it's strictly necessary for any of this, and we're
> > just shuffling code from one place to another.  Probably I can just add
> > that improvement when we add the next zonelist.  In the meantime - this
> > makes it easier to add new zonelists as-is (and just makes the code more
> > readable).
> 
> Sure, no rush.
> 
> Feel free to add
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> after you add some text on the added zlidx in the commit message.
> 

ack. hopefully the explanation above helps.

I will work that into the commit message in a reduced capacity.

~Gregory

