Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC85CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB608E00CD; Thu, 18 Sep 2025 04:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2D68E0093; Thu, 18 Sep 2025 04:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D85C8E00CD; Thu, 18 Sep 2025 04:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEA88E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:23:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B326911AC13
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:23:27 +0000 (UTC)
X-FDA: 83901681654.13.B8E5D64
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id 25AFF80006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:23:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3+bEKqPq;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=MqbntZVI;
	spf=pass (imf02.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758183806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhEheeaLjj12Q7mtWCuLhPIe+EYJsdjTeuBePvxpVHI=;
	b=aZZbkn4sHRSWmvNFTTgE0O8Gg3lhAC0TyyOJyFqXq5qvSws/uishZ28E8l/Pi+5GFLl+wX
	Fg+t6IkaBBVb8kUHkwnG6rBSdvDVCYlWcpLnWrpMC+3FTnpRarX6jayEALIGNOrm42jyqp
	OcaoqfUkt7pUPz6oUBzX9oyudgOv9nc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758183806; a=rsa-sha256;
	cv=none;
	b=bRI5VjzAiNNuIwmQfC+HVq2Y/ogIcxw0UiZu9Qs40Pw60Oyl2Ax8cO3qMmzqbJTDc+GKrB
	wsAkYrXfEJhFBgIRZPvHf1HkTPF+EmfM3FSVKg9n9JHYxyGnZrHyP0y9kdrVLk9EXnWLhk
	2CdwKPT/gmtRVuf+L9tp5KQJ3hvEAuM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3+bEKqPq;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=MqbntZVI;
	spf=pass (imf02.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758183803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dhEheeaLjj12Q7mtWCuLhPIe+EYJsdjTeuBePvxpVHI=;
	b=3+bEKqPqOkUEh6yS9o4ChhOb1k52Ky5bVGvD9xyofVq2LCseV4zCUGvhpgXwjYxYsC5WQx
	yGf7WKJhXXYD0Ru9gsJ2HhWSCvTY8ZssNzpV3GhTySt+XxFzO6qDcVtS4jpjLDDB0sp2CG
	nZ7oWjZkVT/YcKju2TTXTEedsmjkptE8yCpJczw/jGJrnsU1+4R5P1g/EB6TKbndSV/0fJ
	UFMSz+q/92de2si2SyyiSBpZf4y843jj/KRsTtTztTQ8QK6WmaGWMuuZhfDfANJZPWZkYg
	VrBaCRba5VrbCfUUWBvx0YZ+UyvQoF7XZml/fh7TnM0nfgpAzfuBSlrL7Tr2HQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758183803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dhEheeaLjj12Q7mtWCuLhPIe+EYJsdjTeuBePvxpVHI=;
	b=MqbntZVIqi5UZvsyX/yRC/8YSYRz4x5RYd09EJQ+DsufyRhtx9gmkUl8tFF7x7EneRFTin
	SNeyNBFCRxEVhFAw==
To: David Hildenbrand <david@redhat.com>, Eugen Hristev
 <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
In-Reply-To: <f8d3c2d4-8399-4169-8527-3c87922f2ef1@redhat.com>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
 <87a52u9jyl.ffs@tglx> <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
 <2bd45749-e483-45ea-9c55-74c5ba15b012@redhat.com> <87v7lh891c.ffs@tglx>
 <95ff36c2-284a-46ba-984b-a3286402ebf8@redhat.com>
 <24d6a51d-f5f8-44d7-94cb-58b71ebf473a@linaro.org>
 <7f4aa4c6-7b77-422b-9f7a-d01530c54bff@redhat.com> <87segk9az5.ffs@tglx>
 <f8d3c2d4-8399-4169-8527-3c87922f2ef1@redhat.com>
Date: Thu, 18 Sep 2025 10:23:21 +0200
Message-ID: <87jz1w88zq.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 25AFF80006
X-Stat-Signature: utpc3mw7ix64ho3bz3kxjiggga877qx1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758183805-899132
X-HE-Meta: U2FsdGVkX18dPvQ64xKisKl9MqNP8SrhXunQf8T5a9JnM/G16YmOfHEcPZNCBzV4Bmw17jA+8dmRcI9zXhcZYd0u1Gbnv8KeTK7wo2kz36Zi20FYdvQX5+87h2q0q/atfaCgnrDNpmSJ39toSJqIJ0StLGYBB2VUUd4UWv3ch6TMZ14crL+++HKK0KO3gsZYScuG9qzUeWaAnVpb78poHsgL49hNs4krtO84PJjyYeRgrpiOmYLOx5BlFBd/dYpDXvs2pxDOCajX7K7Xri3gWat+zCFITg5yr3hGLqme+1Db/k6jUHHW7EBBJDZMBwu3Qxxa50aQDIMJmvwA/WBC0VUJFBAr7ufOKSVF/h8uXnE09UfvdnBqmKIpFrFWPBZafosGc0nALCgR6o5hZjEJ2oyMrtURGCKlOqMyLbtpuhHwrKm6zX5c/b9jy1H+xrISFvHAVieNZiMuAyZv6tKj/3AYGPPPB4uRlbZedFDB7qQd4so1QlNMdutlyA7JldoLgePcTys9708u16TKiF0ikQJbYyTunDfsU7fi4Cj1IjwLqs3K3oUZIhqG29b8bNfjf9M7VjY7AYccdek3LZmiQB+RGH8GQgCJKkZAMeNSWfEutSm4dASgIYfBuwl7sHNB5LULwJmPOlp6lwe572APSBmZdliOk51+MMWQELE+S229TZRZzxm70kSNr+TZIAsPHfxIS1/5A1zbaYj9w4qc9ATDZ9TaOsVy/Vam32k40An/TAnqkHJQ2SewxdsXcWF/t2Nh/Ua9oIZfykZOrvyl0udbY0/Eq8DpBrx/P+D13duiw5+R3nxHO0j0qJJQSfQBNShS9j+RuilVDc+oxGnpjqwSIBn+jaI5oS04xXYzduLqfieXQCTXPoiujWckJRjQjYDqTmaR11u/Ef5RXUxRXKuaUb5X2TrDXXd775Ur/uLN8JkgAAR71tbOaNsUUjrVrseFwwqDywWfonseX9t
 1J+I8XJh
 PsFZ4e4zLpKjuO30=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17 2025 at 21:03, David Hildenbrand wrote:
>> As this is specific for the compiled kernel version you can define an
>> extensible struct format for the table.
>> 
>> struct inspect_entry {
>> 	unsigned long	properties;
>>          unsigned int	type;
>>          unsigned int	id;
>>          const char	name[$MAX_NAME_LEN];
>> 	unsigned long	address;
>>          unsigned long	length;
>>          ....
>> };
>> 
>> @type
>>         refers either to a table with type information, which describes
>>         the struct in some way or just generate a detached compile time
>>         description.
>> 
>> @id
>>         a unique id created at compile time or via registration at
>>         runtime. Might not be required
>
> We discussed that maybe one would want some kind of a "class" 
> description. For example we might have to register one pgdat area per 
> node. Giving each one a unique name might be impractical / unreasonable.
>
> Still, someone would want to select / filter out all entries of the same 
> "class".
>
> Just a thought.

Right. As I said this was mostly a insta brain dump to start a
discussion. Seems it worked :)

>> @properties:
>> 
>>          A "bitfield", which allows to mark this entry as (in)valid for a
>>          particular consumer.
>> 
>>          That obviously requires to modify these properties when the
>>          requirements of a consumer change, new consumers arrive or new
>>          producers are added, but I think it's easier to do that at the
>>          producer side than maintaining filters on all consumer ends
>>          forever.
>
> Question would be if that is not up to a consumer to decide ("allowlist" 
> / filter) by class or id, stored elsewhere.

Yes, I looked at it the wrong way round. We should leave the filtering
to the consumers. If you use allow lists, then a newly introduced class
won't be automatically exposed everywhere.

Thanks,

        tglx

