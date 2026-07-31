Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 698CCC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314616B0088; Fri, 31 Jul 2026 13:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4C36B0092; Fri, 31 Jul 2026 13:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201836B0093; Fri, 31 Jul 2026 13:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECAA26B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:32:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40EBEA0505
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:22:45 +0000 (UTC)
X-FDA: 85049741490.27.CAF0A1C
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40FC0C000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:22:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=qI2D0sFg;
	spf=pass (imf10.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785518563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzJMQv3xVzAUCtnkpzcujRghNUggd4I3z1xPzy1NvXo=;
	b=Ztp9F8yaEcdYwBmcJuT9UDOobqIwnVJokLQ0LsEKVCC73XT5k/5rek92nGXiz//WU8EnYL
	LOuwKGMEZ+j3yCVK0S1wBSYAz2DMYnQ5S66EeVZal9T2N09odgACZcv1nRFhY4ndp4ZJ2g
	tf5vq2r4Swx9AwrhYZ6/RdfNsntP/58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785518563;
	b=NBBkwkFipB0MUgBtTOclhsI6C3PzEN1ESzbKG+H/0FW6uwN+884AzWV7j+XqOcWfDk0k0E
	POZ9aWH7imC8BLTeXwatmoBzLl65t/D81HllwzEo6zWPLE7mHsSvpxMQTF6miA0+jAnhdF
	wzjCrBOIY5mVeQ5zNoE0EpJgLnMesOg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=qI2D0sFg;
	spf=pass (imf10.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id C5B5D19F5BA;
	Fri, 31 Jul 2026 19:22:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QzJMQv3xVzAUCtnkpzcujRghNUggd4I3z1xPzy1NvXo=; b=qI2D0sFgvOvwu8u48r0FzVvH8c
	36lVMmnUJecBSk9vJU8oSnhGdAwXdyGAEe61r1/ijGLeQjH+kRscMRVLfJQjhUcZeVkwOxcPs01n6
	aBr/+ggQefDd+Bg2FRnHCxboX9paLgF99p3zxoqB+rXxtvaG9GPMTclHRpBw73ZX/aU0=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wpqwL-00000005Lmm-0Wdo;
	Fri, 31 Jul 2026 19:22:33 +0200
Date: Fri, 31 Jul 2026 19:22:33 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Guillaume Morin <guillaume@morinfr.org>, linux-mm@kvack.org,
	Breno Leitao <leitao@debian.org>, muchun.song@linux.dev,
	Rik van Riel <riel@surriel.com>, david@kernel.org
Subject: Re: [PATCH v3] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
Message-ID: <amzZ2R-NAiYJhob-@bender.morinfr.org>
References: <amkC_1Ya6OiUoiLZ@bender.morinfr.org>
 <20260730150115.37de0d2306820eaf72834743@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730150115.37de0d2306820eaf72834743@linux-foundation.org>
X-Stat-Signature: 6bc6u3fwn7srgxuykxt9h4jwy3to8wuy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40FC0C000B
X-HE-Tag: 1785518563-3380
X-HE-Meta: U2FsdGVkX1/PRHpf8e8zPeI1EJSvjYofeOP0VJgkuyNCpYnXUBxnL2gJjAxVNVbW4UG5eeTV4AfgY49sVb/ZNhHfAOjWprYjF3CTISq7/NeADIP5yExlF1InEcg+eTRTfctm/g8al5qrE2l7oECyEHbQVTqgasdsACbTzm8Y75f0yUyqZFFrx8cXdtKJVRgUOGuo9cqpaTqhByxX1ug+Ml62AdTPTg6eG74IkZ8OO0eDSIZnMyWJe+xxQu+xaeNleWNhNx0KmKUhoIfK6Xp+vMlKf8M2yZohBge7EDge+Ps16o1hKdBjLMXXk7Z1mtDZclCyBZICGOVe8A3G1aIWKskNeA+l1BTJWve8dbupsNdLtJVNq7J0+j9qU4trqXBpvyqiTLSU++VBK0cWFrd2wi8pjPMs6WWDwhZ2zo06NFeZOnAs6yFR8A6yUOeZO5KkshAmcd6IjNGuI5MUJI9t4EiaMbfDcOwJuUAPb/IPf+KJvCdua3f5Fh09fV4tYPLWv0Jd9M90W4+6YTA+7bNGpxseZOp2KMVBfk3sTIdpCqkfOp4hE0fFtG4VQfZNtFWikw7TvnoCWd38cbK0Do8wAo19jiWwVRjG6su140i25oCFi/MXDGHBz+cnnpUN1qvV9Sg4ZgwQ405ryKJODr0+gn6oYH0yklMlWjik7EHo3+9RsgEtcx8JrIAIxNqtosqZzSQ5ZUkI1PazyqsOdoT0GtNMPs9bRS7LkLX0Ndjep2CKf3/FH6fNrA/7atgBh0Z15ym6pvROEj/SXbNE/voPvpmS84RZxvkLq4kxMi47JsNfyXKc5gxKYK0lhtMnWzq0YnmJ/RngPNr7gnW95HL3n66DdGZV05c+OZkPFKc7SKz/9ODSjmS82MKfJ6Q9MYOtxTFq1es7IeYr8PnJm+72ETrfiF0fgQaexqrV5GA+cluwAkpfin267f1fvCykNZXLCfX1i5eUA5aLNaQcFNO
 b+9Z+HaD
 H/nFI6AIkWfxuGeZ3XmLTgNiOarXy3mcp2MBQJx+wWYnBUjZelqgi0PP28iq7itqGarI0sJzr6NMjE++DGgKaCm2JKV/lupEpVzDmIdVxxP7I7A5b2yeE/MEdCmYBKAwY9WV9hKSo2lnbYI3BrOmju8az9Gulv9Cf3QPSR59MBr3AmaA3k7xDk3dHRxfuPWwA9qC18uLQry1PKL7aMTusntXXeByKVrun1fTmfZ44QkGDZT1gV8ljbQLnBCIJCpYJ5FI4HBibn32UWob4e/wYawAiomO0TZNYFOizN3T+u74gMNsC8FNfvPpoYG9htsgsjFQXh52R6+h6ryI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Jul 15:01, Andrew Morton wrote:
>
> On Tue, 28 Jul 2026 21:29:03 +0200 Guillaume Morin <guillaume@morinfr.org> wrote:
> 
> > Since df7a6d1f6405, __unmap_hugepage_range can adjust reservations. In
> > the case of folio mapped in both a parent and a child, if the parent
> > unmaps the range first, the reservation adjustment will result in
> > an underflow of the reserved count. Once the child unmaps the range, the
> > count is restored.
> > Change __unmap_hugepage_range() to check the mapcount before adjusting
> > the reservation.
> 
> Thanks.  AI review mentions a couple of things, one pre-existing:
> 	https://sashiko.dev/#/patchset/amkC_1Ya6OiUoiLZ@bender.morinfr.org
 
Not sure about the pre-existing one, perhaps Bruno/Rik can comment?

But if I understand the bot scenario correctly, the new issue is
incorrect.

The bot is correct that during the 2nd fault region_add() will
return 0 when the new reservation is committed. But that return value is
changed into a 1 at the end of __vma_reservation_common() for private
mappings (there is a lengthy comment about that). Therefore it does not
fallback to the 'hugepage_subpool_put_pages(spool, 1)' path and
therefore there shouldn't be any resv count change.

I wrote a quick repro of the scenario as I understand it and the
reserved count is as expected.

#include <ctype.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

int hugetlb_nr_resv_pages(unsigned long *num)
{
       const char* field = "HugePages_Rsvd: ";
       FILE *f = fopen("/proc/meminfo", "r");
       char line[256];

       if (!f) {
               perror("Could not open /proc/meminfo");
               return 0;
       }
       while (fgets(line, sizeof(line), f)) {
               if (strncmp(line, field, strlen(field)))
                       continue;
               const char *p = line + strlen(field);
               while (*p && isspace(*p))
                       ++p;
               if (!*p) {
                       break;
               }
               *num = strtoul(p, NULL, 10);
               fclose(f);
               return 1;
       }
       fclose(f);
       return 0;
}

int main(void) {
    pid_t pid;
    unsigned long num;
    void *mem = mmap(NULL, 2048*1024, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
    if (mem == MAP_FAILED) {
        perror("mmap");
        return 1;
    }
    if (!hugetlb_nr_resv_pages(&num)) {
        perror("hugetlb_nr_resv_pages");
        return 1;
    }
    printf("Before the initial fault, number of reserved huge pages: %lu\n", num);
    *(char *)mem = 1;
    if (!hugetlb_nr_resv_pages(&num)) {
        perror("hugetlb_nr_resv_pages");
        return 1;
    }
    printf("After the initial fault, number of reserved huge pages: %lu\n", num);

    pid = fork();
    if (pid == -1) {
        perror("fork");
        return 1;
    }
    if (pid == 0) {
        // Child process
        pause();
        return 0;
    } 
    // Parent process
    if (madvise(mem, 2048*1024, MADV_DONTNEED)) {
        perror("madvise");
        return 1;
    }
    if (!hugetlb_nr_resv_pages(&num)) {
        perror("hugetlb_nr_resv_pages");
        return 1;
    }
    printf("After MADV_DONTNEED, number of reserved huge pages: %lu\n", num);
    if (!hugetlb_nr_resv_pages(&num)) {
        perror("hugetlb_nr_resv_pages");
        return 1;
    }
    *(char *)mem = 1;
    if (!hugetlb_nr_resv_pages(&num)) {
        perror("hugetlb_nr_resv_pages");
        return 1;
    }
    printf("After the new fault, number of reserved huge pages: %lu\n", num);
    kill(pid, SIGINT);

    return 0;
}


-- 
Guillaume Morin <guillaume@morinfr.org>

