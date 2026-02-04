Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9EEE95390
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 12:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD626B00B0; Wed,  4 Feb 2026 07:04:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50DA6B00B1; Wed,  4 Feb 2026 07:04:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CA46B00B2; Wed,  4 Feb 2026 07:04:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 908E16B00B0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:04:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36791140110
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:04:58 +0000 (UTC)
X-FDA: 84406643076.01.8F78351
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 503684001B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:04:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qgt3gasq;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770206696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTI38envbZN9fduycNacD7pj4fl/oCX4AVN1HKxV/jg=;
	b=0Nm3Qr25PcQvIvrHp/45JMHzigbhHwTJjBu9rCsUy4giuZSz1jkR8n7E0CFIHAuAqXROXI
	A0eZ+zFUv5H63PCP+DPqG74cElMc0326OSCSC3tKsdACs7ktBIvbCKQCGNG/7ALYek7YR0
	Y9uzv5cBvuHWNW72r/Ja97BE9V1PX4s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qgt3gasq;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770206696; a=rsa-sha256;
	cv=none;
	b=08ZILw5DgwNea4QqYoYRPWGTWOggUg7AQNWvTwHGgfQah7xuqkgUBPckSwSlY1CozHj6CF
	ayCaypIRWgMPk8t7LzUELJD9KHRuzmaoXryKPAzqBbQWJP+hNH2khZ+x45EXw8bcnR5py2
	HK6EAGRyANqROVXE0ZspQwz/I8uVBdk=
Date: Wed, 4 Feb 2026 20:04:38 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770206694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTI38envbZN9fduycNacD7pj4fl/oCX4AVN1HKxV/jg=;
	b=qgt3gasqhkckRLUDm00tqVNsqlEfvqN6Xq6Q7hLF84tAOunjzlA+n58plgndu70sUFR35B
	It8hwBDzSzHDQrBUv/tsKBskXsEiVSxnc5dgSAhqkcR18lmlGCUqt5uKR0yHJYF8pOqvrw
	OTHu4BXMzscS8fr2j78aICkRPp35Oaw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Hao Ge <hao.ge@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] codetag: Avoid codetag race between same slab object
 alloc and free
Message-ID: <h3hzjqgfur2bzedmbdsnxpzh3strdejkgya6quul6f55b65pid@vutmz7mvnzrd>
References: <20260203073006.151710-1-hao.ge@linux.dev>
 <aYHDMvMUfKj4_eDe@hyeyoo>
 <5b8e12d6-269c-4979-b99b-b3b4177aa00f@linux.dev>
 <inzhzqeqqvjudozqz433462qy522deyl226jfvajdkw3eerodk@bjoiaorsesuq>
 <3de9129a-82e1-430e-8df9-7063e7d2129c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3de9129a-82e1-430e-8df9-7063e7d2129c@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: d6xpmjyn6bt5syz755imsrzjcn156g5a
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 503684001B
X-HE-Tag: 1770206696-194257
X-HE-Meta: U2FsdGVkX1+is+eld2JODoB3cjsSoAkKBVkY1Sb2VQiwQveETQwis5pI3YioJPM8zT7s3BvO6mX0Q3n+IwSP6AMakD5A20Un/bol2M+j4Jo3QJLbTmAotN1dTH6ISs/X64t4uhsGV1CVFUfmLLju3Fp2/a6H6LKYCLkqcNCDpJzQcC0lqVzie1Nfb8UvUSyQTKh2py/JxJ6vyxddSdCYGbgSFsz4oMIAYr2YY8cchlBmTFAxJ87u1RDrgy/qkvmJ9mGbatwVvuieP6pMCyhYFGjs/XnuE1/NKfnHTL/u9cJGndtyOy57fkHE9eRkodtHvKswPvbL2AoD6ocXxuZWxlXWmVV/+P2pgGO5GaSrSKQCjKz8X6eXXpIWoG7dNYHEPhb6dO094o6mHL44tvu16KK64LfqeOaGolKkl/787wCNUeulj4j0+NZ9yIvm0M9yYI3TZcFQt3SVogMWMUUcdOWYKbn1/YkwVsNqOjqyFLvzzk9K4hlVTSTgMjLukn3V5n34ovWU+nxl/KnwiLVbLm8QnnkafAvowjf38qv9vbKCcYktUefUYD1ZyNq6o2+le3JHAE5GKVYBjiqtUc+JTti0ktnBYOF3uIPNBxz8ChU2xox5ivmuLHT9q4AlfpJUq3cxxN9JdAcHCNYZvJ4AYJMap/I63/ZvCmQ9dxuBBKR9J7HNR3IqRwc/wjRovdOooWwlTR4JHp4FR50YJ4WnIN5bVVcda6GyxSNoGiyl8qX2LCFThp6fIbfR/Dmg7VmXo7KXfk2QT8OUaNMOxHQ7FYN23tF+6k1hiLqpHhNIb6zAr//hghT767Jsh/frU1VxGX6Lc6E5wfSck5b8VLcXlhTrdPhbnfv2615TaVR2Dcvin0GFepUDrwiK8uZGoftSdMZ7L7ASwdv1eOeNWD9ojv6OGl+TdnHtUo3Ode1RkMvPKwsCpzdcELEjQ7O4/wBUCh3HHM8ivIXkGO1Z98W
 yXuOFfIj
 fjtemO2+IzH0/UMGcWyifXKJvH9IreI+4NplfwUBNm5I8+oZe++pk8i+tfWJp9TjoKTAP5VPve7yVtS0yifJiWVcd9xRUdpK6iDF7f9IE3pYw1GksNcdV24DTcYstf21arSX+DpOH9PZ5HLECVfWix9ukyEG0k7K43NyfDKz4epRN5zNZVE/ucP+csl+Ey3i3nFb5YWDvcnk6+FSvCHLe2XypjfvRQ+goVpDP+2e1liXjARNOxjmSiu2vG8lkJQf87HX4jpJmT/CS21KDxp7biPn/fPGIKuy7e8Y7QfhqhlQiE8cTXJFxDV1S3YI/Rb/VehcjIHO/sxumQ56rjqx0mwXo1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 06:24:42PM +0800, Hao Ge wrote:
> Hi Hao Li
> 
...
> 
> This v2 patch incorporates your  suggested fix.
> 
> https://lore.kernel.org/all/20260204101401.202762-1-hao.ge@linux.dev/
> 
> I really appreciate your help.

Happy to help.

> 
> 
> Best  Regards
> 
> Hao
> 
> > 

