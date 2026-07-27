Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DED2C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804B16B00D1; Mon, 27 Jul 2026 11:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB786B00D3; Mon, 27 Jul 2026 11:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C0A6B00D5; Mon, 27 Jul 2026 11:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 480346B00D1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:52:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4B601C0F4B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:52:33 +0000 (UTC)
X-FDA: 85034998986.23.726BE6A
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4E5D32000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:52:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=njvg48Pc;
	spf=pass (imf13.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785167552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDZFA/XJVv1lEwaX7z09NSQIhGALV+zbSDqdbk5QFJI=;
	b=C2FIdixP2hRf839YTs+161QXfJxzzMpkmmZNL15spggCcDl76vptghMeCdKjGnQGL+b6jj
	K8D1TLHYMclljlLaDY9MYqhjz58Q1l1LgYJeaOXg4JiFKjkFhF6odXr61NMkbqndHDZl3s
	KYq4gi0FB9aZAt5jaO5pq76aYwDOB0I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785167552;
	b=5daAFK5HCJG/ZNYI94wPpd5P56tGDRYHc3bJ0rTnUBQMoYK0crrtgs1T/RxHIxyUVsvEpi
	5kp0LGtQdAXL4zs9krDOCGeQuMCV6yoYhuQxIQ09LI9WkOVdI6VnWcdvacRpkK6KyLkZW5
	ZZa8thW83lTZ/ylHuTC60cVKFwbgqNw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=njvg48Pc;
	spf=pass (imf13.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1785167551;
	bh=aDZFA/XJVv1lEwaX7z09NSQIhGALV+zbSDqdbk5QFJI=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=njvg48PcycPtFPoOTl3CKDsU2KSL531LnK7Nrfj5zu0ysmTZD2WhlmwerjidKOBAB
	 lC+9ypga8F8tcybI5Q4JbigDHtzYEhNhNA1HiuReo4nefi9LkTMqqyQU7+Rpkb5ne5
	 EDCLWzlaTgyjtFUXdMP9tlILmjcScy4dWWza2SU8=
Received: by gentwo.org (Postfix, from userid 1003)
	id 30728406C9; Mon, 27 Jul 2026 08:52:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 2E99C40112;
	Mon, 27 Jul 2026 08:52:31 -0700 (PDT)
Date: Mon, 27 Jul 2026 08:52:31 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: print just the function name in
 /sys/kernel/slab/*/ctor
In-Reply-To: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
Message-ID: <880f61b0-edc3-cbe4-c775-056a46452cf7@gentwo.org>
References: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4E5D32000B
X-Stat-Signature: y5crmjes91odrou5o3fbih3rgrng881p
X-Rspam-User: 
X-HE-Tag: 1785167552-980257
X-HE-Meta: U2FsdGVkX1+uJVijDKgCv61IhMWrCFw0vcaQOgVhuEKu6PgQ29Qe1K5VvFlbPXxqgYq/sMQzVeQxEWq/K2ftILHwv5QhB44+h5jceF8q01RaYL1etI+HCahjtQhz0ltEga/MqJMGrb53D/uKoCur57B+PlGkQdAcNCxY2URYhocDRKGSKR63eilA1v0/nOs9W11qdKzCgayVsSYS5EItfXSY+kibDoynNeOdJ3dDxZ/diBkTzB6wsdM0nNs7vq0R4dwOHTSi1JZ7PO8iu+1XssksDhjG59FqnmkCN8qRgZDULbyzqk/q1qQE84U1cKL8CISsd7LVIuEZBhF5RSqU4IFz7vCs6JHS890RtmLYmbvRXkgHevgEjSRndu1Na9ORgv922qSHJpOLfaesRv1vRzv9Svmt6OMTdStaPVnLW91C/rqSCxZavyEFw+q4Of31RBvjd73yLQ6BmPOQabTAkTZI2D9XIHNGbpTSjNXDwQUKMxU5MNZje71psG7ysfuLur1OejHR07bE0trMQwALBAEM/vpAAwQik82r3n6k2rH8+50FMZDgdDNVcJgqscpAWV8nTq5K7qD7A6VDY0nNyztbZHOt0xi7GwFd6NRcjfTjiqWfUdLgSCmBFd+QS/O4dkKu54n3TXWuHX1gzyXLK/mq1zcZMw7hSGVkJEN2fzjzZLPbjkitzyKkTpCn6GePHC61AmVwHOtz7NArU5TgkdgIC1J26LAXEAwxoRxwCqsThjjnL5vASUeKElXbkC+h8cpjxG/NV6F7hPixkcVkn5Vb7cptc0LuxrRzibsk76wcj3Nzk4LYV1yFN6m8wjqXnrhdkTDrfZuQPhrkTckQGVsjLAISqJeEot37kyJEc3k408TWJc+xAIAdbc9LrTh69e0jYa9O7jPq+N5ih94r/XgqBENq0yM3TFwJEBHDDWS8LPKIan+2ZLCZvigxmKYeBRBjhekUu3KNGnH1PlH
 3FKQGgJ1
 InLme+/vX0FDSUdGK/xnjGzNMk24f/EZ+/+h6FQYAnp9st7ltHNZ1TrmEzwqDPlemevnJR+xRyue9hKIK8nDkmQify6hQXg1Aet4BfEhuPwBwoVHczm8dpZaSj5qToq2mqWwCWqjSbp4aFr46vLI0Yd/xWEou7lTF/HyVuUF3Be3oLQiAfaXsqkd4ZxVX5nusJZFiHzYU+QOOJ3RKPdo2yMaDOxElKwfg7cAOQTTu2lcUH+87U9owEZnVKJPYGTAjDuN3A9fcu1lGBUQAUIOJGpXC/jAVtS3apG3W9foRCxopAaLzfPpuyBTcQxYhGNEP0rxF5+iHYKoseJQAps+hg67xLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>


