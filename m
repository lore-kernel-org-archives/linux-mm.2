Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C1FCC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 12:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768956B0005; Sat, 11 Jul 2026 08:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FAE6B0088; Sat, 11 Jul 2026 08:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655136B008A; Sat, 11 Jul 2026 08:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45DA36B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:15:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D37FD1C3BE5
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 12:15:00 +0000 (UTC)
X-FDA: 84976389960.12.623DF83
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id E330518000D
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 12:14:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aAWb8hip;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783772099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FtEN2DY+BxxaL32RInp6wxS57TN+4I3PQgB5Cdulb5M=;
	b=OWj6JmOjLlNkHo3pQ0d6L2FowC2P3HM1Ai9xmDy50a60GD90xeaEeAltIrvoItAdziPp5+
	0pPJWySaVQhsVKniXreTTgr883epp/RJK+SVAeCK5IULUUbIhAQRGrofBKNXoD+ZOF6BVC
	M8sAwi89jdCYBeLTtVl/XLKQRYsK3aA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aAWb8hip;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783772099;
	b=xvDbAYThBRmcZFyoT2Aaf3V13b1NXYEFOyVzRnPa6N+46Eoy4XZm8inERJbGSBEdWLKV/P
	jyKjk4JDqPB0AJ1mrlNacC+qKbTCaOx3UOBkzn9KUwMMdpja8x9CqX0iLl5lAi45VgXEQb
	FfVVD1Q0vUHRofBLGiBJF/TDDZt6bvs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 755421682;
	Sat, 11 Jul 2026 05:14:53 -0700 (PDT)
Received: from [10.163.130.35] (unknown [10.163.130.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 114533F7B4;
	Sat, 11 Jul 2026 05:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783772097; bh=F/ziK+aYyEo8PRUERwubyag4Ur59hUdVZDJM2fNt8Dk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aAWb8hipmFXsiY9MA0Qe+KtOdGRg2sgvYwXOX5q7f+W5W8N0fsXtCMW93MTV2o3/8
	 CVVEz6AY/ir6agdcy+VI+QntuBuY1/noON6RtLfd1Eh49d3+zzvCAlDzDlTj3LOx6K
	 BqNNKYJv/G5jcJXkZbVK3gAuGu96CkUF4kPtxQoo=
Message-ID: <7b21094b-fb68-4cb2-8df6-30f6b6dcf0c3@arm.com>
Date: Sat, 11 Jul 2026 17:44:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm/rmap: add anon folio unmap dispatcher
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-6-dev.jain@arm.com>
 <00467fbf-0360-47be-94bc-d1456323e5a1@kernel.org>
 <42300e6c-523b-4f58-98f7-672ce9173fe2@arm.com>
 <20260710173519.d7659f9705afa37ad62e7bbb@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260710173519.d7659f9705afa37ad62e7bbb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E330518000D
X-Stat-Signature: qucuy64a6z77137mnm3drx5ih998trzx
X-HE-Tag: 1783772098-470153
X-HE-Meta: U2FsdGVkX1/RP85FN3xvi8kD5NYYc049Cnii6dauoyhrOPSDtBOI9DrTLmXED5ogzrFnpZcJNxh7Iqc9CTjESxOXnIj1osXsHp6CsvQALVON2hpM0OMbpbrSHE/8FzE5t+gyPNufDJgXpDsubnWHh/Y4vlv5m38+lC0XtpXPV/lPX9yC41VZgr0cQtje7f8Kb9xMbkuAZeJpOBqKjnTGN469/++32SEiqgHgQAUI7cbXVdKil4mSKbZsqZ9OmwxyHXTC2fB6TH9VK+cnmu7rIq548vOOfce3+dY46FgdSsstspCzbLeCQ3VoVTbjwA2dQt5raWPBr0A4Z1RdJJuXCNzDOF52HfXbApAJ5ctdngfJ4Sru8aO1HZsIfmRBnUI5ZNKH6JI21EieHYVA2wWXVFReWhwHUurW4hrA+9nbnkoXU8Pr4vatwllgaFnyWJfIjZMxJrINAtXTw+5k/hRcjsuaZAYvURvK8sVVeTQpPf0bo3P6M9WMfbrKDNCaGXrd+i03VGTAP4w4GU61HMnCkMbdNjTnF+8JVECfjLpLgbJu1tC0qPBXiGeTZvngPPzhI1hLC5W20694VwDPDo7cAwI01UCTEyMZ2Fabb3wwRVGnCvB6yyv+lsRUc0HNPeNzkOTr2kFMqUEFhaVJ89JYo06o8Tq0z/D0XQkbEzMmEsmDt6gtcBFZhwDrYq5V0IoIVE709xk/nl9kAw9jVRbP/fIFUe1bo+oDs9A1EyQgDX++oHa2EtPbOBWPsoLNCpJf6tqa3rtCBOEddHsxVelkSsbUdxk9Gz6+Titz254n+U8h1fse0RyBbPFsT2voW2xul9r7mY1SupSc9fNGAq2OyYnOgstdjnZHMljhq956NEOqSmFJcYb8+bA/uoWR/iIHfAAnVj/6K2mHybNAGcPcQ9nRP+79rs7y9AtT66IdvS2djMUhmaDcNAzP+7dsXo7RgfsngldcnmqS7/plFHW
 c8aJx08E
 jLKU14lw7IG+92l9F3ctDAcYYoDnHAlqLMPx7Q1QYywkVEZz5gKXV+emKnovM0qJ2LrrizLYNrGidIDr4DTEXOfEX4wYRBM+qi0qaPjtfdrQ52YWOf58A4sd1ORscG6vA+gNl6mfDeusZPPhwPhmlhqqleo3wtRavi09EU7L1voyTKxQ0RZxjhzxc7hicjk+NKfItZa7gQZXwbmaLqHtu/XGXmYqBPUhMl9SN9PpL/TjsX9MC/Tzt32n3QUcxHJ6NWAL15GBVAdj7mjeCIdCWk9usTh5djvdnd+vU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/07/26 6:05 am, Andrew Morton wrote:
> On Fri, 10 Jul 2026 18:43:14 +0530 Dev Jain <dev.jain@arm.com> wrote:
> 
>> Andrew, could you you squash this diff:
> 
> I think I'll await v3, please.  I'm getting a big reject in rmap.c and
> methinks we're all a bit firehosed at present.

Okay.


> 
> Are we all agreed that we'll be "batching anonymous large folio
> unmapping to optimize it"?  If not, is this series pointful?

Even in the impossible case that we don't go ahead with the batching,
this is useful on its own. Just see what try_to_unmap_one looks before
and after :)


> 


