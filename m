Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F01D6C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0748A6B0099; Fri, 10 Jul 2026 08:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B356B009B; Fri, 10 Jul 2026 08:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4286B009D; Fri, 10 Jul 2026 08:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFA756B0099
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:44:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7175E1C3B24
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:44:58 +0000 (UTC)
X-FDA: 84972836676.27.32D3744
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BD263A0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:44:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Aq9/XVc2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783687496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjYAwAlPO4kCkyKKShGdEkZAiem8rwBuoI4ZR5oU76I=;
	b=EiVKkzV2z4IUeP8Qi/3GPn0rD2Ae8AlgYto7T/xdIcQd6FgLOFO5U7oDuKdUcjYpVpVhtd
	C5UW5tfAdjIHFf3LZwZV+Hou+nIUkdyjcJfqpUSa7YzZzU+P5lmWn811Tf0uUBJVArDBm/
	0j0E1Y++W5oXWz+yJFN+emxYLUa+Aew=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Aq9/XVc2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783687496;
	b=4wW8ISBpbs02P1Vk2cYbV9DZAYlt+XfO8iPkKABd7R/ko8B/3sngFOzCbTHBa2R1dbMtF/
	WH9xqpmuL+oGv5HdHs9oLUMyNWHmskp2j6ZKdpESpKGslobB+ChP23CIP1XBiqvkoqWV4j
	Zgb50yfmrCISNFAIdFky6ugGQGx9s4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5357B60051;
	Fri, 10 Jul 2026 12:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16581F000E9;
	Fri, 10 Jul 2026 12:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783687496;
	bh=pjYAwAlPO4kCkyKKShGdEkZAiem8rwBuoI4ZR5oU76I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Aq9/XVc2asVR/Fy9ZgOYz3xnFcflkjhg3GT6s9NBh+sDrn4kXjTrTaJAGbSMsa8kB
	 Z1vp9zGGjVTBwXhepy3tF6YuosCiC3E7bgkaJ0mkKbGsBes59ZrThbfW4hxyQDriFm
	 i64VEfHi3vBAwdQLqYHFtHUSpSoZJ80TTzrF72AH0yVDtJOflXlsox5D9grQ7YTDJ7
	 greWidf3QwAkChMvFeNWTkqP8T1uKDqsqtY1Z9sFJugMXDGqMYFH5f+rMI0bT2QShP
	 xJoFUNnr/kJ7sgZtnU182krToDTJOwsEIRUvXBisBx//wQ6gr+CHmyTk5DZAjoiINf
	 BIslge5ccYQdA==
Message-ID: <2116d58d-48df-488f-88d7-523298f78e62@kernel.org>
Date: Fri, 10 Jul 2026 14:44:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/10] mm/memory_hotplug: add mhp_online_type_to_str()
 and export string helpers
To: Gregory Price <gourry@gourry.net>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 djbw@kernel.org, vishal.l.verma@intel.com, alison.schofield@intel.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, iweiny@kernel.org, Smita.KoralahalliChannabasappa@amd.com,
 apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-3-gourry@gourry.net>
 <bdf0ca14-eec4-43b6-93aa-310e77660d95@intel.com>
 <alAZLBqgUEZliwk_@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <alAZLBqgUEZliwk_@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BD263A0002
X-Stat-Signature: er6sa4coe5pwxpj7da7ac9dwp1dkar9h
X-Rspam-User: 
X-HE-Tag: 1783687496-137410
X-HE-Meta: U2FsdGVkX18/X49ZRu/nkfSuUX+MHZaMGPujC0ZV5EQOOLJANGryPKqc9CegEmFdmEdJHdcE6bQDgu0VeYBVqGOdjI/Z5BhGKbPVWDnfcEcZKfL6o0vPIqXBNp+q5bFmOuJNM4Y7fODk6nAUafKT9/Py9PBmdOqu9mDmYdyiMT8HYhKWBe1dvJFJcVzCXApqz98ue0ESFLvBRwFovu1jSvPaC45scc3HviConvXyPzOO6uPtaRfo/4lYWro1vJR2COsPCrOnAJA8GbWwhF0ifUeQRRsKt6doKo/aG71xFHZYMBDAI66OUChkGSo4ivhpzVGEpNuL2h1ki0+XXGa6vT+jnKLHgxVYAzacXGBmZGD+mibLquO32mxRQNWbgM1OWJVzF/QC98NUQBGN92+JAHlY869rmQnYBFkj1P4Nf/ml0e49edd7dVllW7UKmFivX7Yk0feLm1LVh/lmwzbcDvV80QRkiUDvdTKFNA1FwNWSlUT3YZchmaYBj1Pt1n4C2AOnUJifbsRowFjbpppOw28wVhf6FvhHCe5YK5RRwOM35ojyXLvlCwFqbXf4l1vwSRyKoxZ/TVaTMaqs/8y5PXw7ZpiORqyJebCjUDwdXffXlDZLAgxDEhdvxRdHAKGQn4sa17J1Y6g9vZdxc0z9Oj2656M4FY96pqF8OusHyIuW2wSjlqRn0R3axkxq6++yI5p6OwS3nPfQ1y6Zog0CrK1326D3xAAdMJfMixcH71DikskhyUmmpuUbD8d6t/ixIhG/exFrXjb8xzV8nvml/GbLPvWL2oh3ewcFe/gS+KmCxC+oGTkGqWIupuBSCI4vgwo34Dtxw7T6P4sitRwedorVGQEQor2AlZmxG8Hm6B/oLLQxBNJhsGrdCSA6ejgeF8EMsmkys/KansbqjPR7WUU5+3Kn6xyNenleoOM/NO8SkIpup056Rp6ViiI6zZehYFNqx8fO5Xa0D0Jz7/R
 zM1OR6OF
 0+g+NXB1rORgF4c1gaEEiDMpDuBPl6eZbuBYSBxyHZhgfrMMnS+gHDxYLZ/PiF40h9HKZd2IquLKnnb/qiKOpPFs1mxEOdq42n4+at6boQ9xpubL4ydoqv+qCKq01dGwS0AT9xzTHEWqi4HixAaBQLatn3PpZo6pRHGwfUuCKYvHLPoKMK+HAvEj0WzthU8uAfWfmxwhiHf7v7L7ngWwq3qAHGUkkZvx87WoBqH0KqWFjL1XDxEkLidPGgQaeDOLii3hk4Mt8mGgk0n5uH2KklDWnE64nAtCO6hRoaiT/MnA8Bv/sAqPM1p9bN2agmjtbveEUW3bw+jco+NhoBJ7pYzsnZvnWeIKAJi6KUuWh/sl3yKK0BGK+TEoBIZjg0XoICwjA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 23:57, Gregory Price wrote:
> On Thu, Jul 09, 2026 at 02:08:43PM -0700, Dave Jiang wrote:
>>
>>>  extern int mhp_online_type_from_str(const char *str);
>>> +const char *mhp_online_type_to_str(int online_type);
>>
>> Does this need to also be 'extern'?
>>
>> DJ
>>
> 
> General policy i've understood is: "No new extern"

Yes, and removing existing ones as we touch the code.

-- 
Cheers,

David

