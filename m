Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F29606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=F9OtPTSA
Received: by kanga.kvack.org (Postfix)
	id 3EFE46B05B1; Tue, 10 Nov 2026 09:07:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3796A6B05B3; Tue, 10 Nov 2026 09:07:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241656B05B4; Tue, 10 Nov 2026 09:07:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E01326B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:07:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2D741A090C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:07:49 +0000 (UTC)
X-FDA: 85419387858.07.F0A329E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id DA22920013
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:07:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F9OtPTSA;
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794319668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o32XJk3B6ikVfi12PbmwjBY5KI6kvxLInmTz1VZt7Pw=;
	b=uOGejK12bAVykw1XMhVMdz+Wnjktkjsf3P890XlJmrWqrNrhDteGTMwtLMmdZh++LgAtWg
	xOWUtkVfpExsAe+c8ucLNNI1E8siSCi1E3wBkK1tG2R1Gs0FABdUCwveX7onWOnTK5WLTe
	FWT96RrprHHfI+NGiqJlyu2BlKyytCU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794319668;
	b=xaZbyDCXW2CN6HFRUXuZQpS44aWHgX8NzKkVUNVVzkR3bLRyjO0lpgV0mqB+rbELPIwNC7
	sQ6oCw08aPPrkPa/N9Ru/A43utnljlgafE1ATW8DeKg9R3LEf/Q1za3tHEi+qf/x/Q0A65
	agWP4tLMfUsMLQqmOVlG4jgSSm2iUyc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F9OtPTSA;
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0311143D;
	Tue, 10 Nov 2026 06:07:43 -0800 (PST)
Received: from [10.0.136.86] (LRYFGMQP07.cambridge.arm.com [10.0.136.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08E0B3F632;
	Tue, 10 Nov 2026 06:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794319667; bh=xqh7DJ+zVV52dERd2AmnJh4G5Obs3nbK4SBhiC/5OFs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F9OtPTSAuCR3v0zdhUomHdxSKOH7WfvEa+Wn3w7XeU8yZoSOHT28dhZIhIxAYJnub
	 RL2VWiMb/wfGV5G7rTJQG2SyTATNBvgIlZGj6KD3A9ecb9VSVMaiJcqrrWkQbCZaAt
	 9STn87OzjVbmYjrZynUmOJVWlSS54fzzO9nNBmNI=
Message-ID: <3f68c02d-066d-40e6-b86c-bf41def97464@arm.com>
Date: Tue, 10 Nov 2026 14:07:44 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] tools/mm/thpmaps: handle carriage returns and
 non-UTF-8 filenames
To: Weilin Tong <tongweilin@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261104061641.1115805-1-tongweilin@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20261104061641.1115805-1-tongweilin@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: eu7uwf7ahaff4ebtgeu5opz51urm5etj
X-Rspamd-Queue-Id: DA22920013
X-Rspam-User: 
X-HE-Tag: 1794319667-108576
X-HE-Meta: U2FsdGVkX18+Bt8k42X33CT5WwK8K54jCaQp/+6AmW3XH9HNcTA4DUC7NCWqj6FZg/bb4X4nMW/kv9N5SQ/bnm4TSt5MCss45vUlqvi825c+ELKZP+ZiNT23SIjOZyMYlJRix9Qa7LMKyFuz24fF7aoVebL78O4HmENHZToL3Ut5nI5+Il2NVphoAkZlJZ4xll4GXhEB7RUQHAdpoZ8zFaz8kFvQCPjMacdZvrlnkhmcgUAqu0KrwYT+yVUpuOaqzE4PzQjQYsuuuI/RKrOoIftyKMzILF+N8if7uPjyhoAkbd4MD/x2D7jyTa3Gn3WfsUx4Oi0owXGzMr9BIFjoUbGWQ892Ol50yDCOkS4VyB6oKGTh03Ms4ZCmG2zO67VZj9HNVlrUxgV1fJpQmZ7X0jMvYSBuBEVZ7aDQUNjDD95t8n/ROAXq8vqR5h407C8cFbKy+DxmGjx16REm1Wq5iQ3duQpp8/B+V9uMlapk3mPMW+6jhtqK+L/YCmrMrcxskL2QRnMR3UhbYguVEmZQ018RLMu8Hnnj9oqpP7mZkJgR5kmDGk2kkjfjuWocLjGL5hRcSs4aCvHrGRIS/P2+l39z6EI94NvR7R4uvCm18G4s0EoI3tiGjqaz+U6mpOOjznpEL7kk0lCW4ZMfVlt4NVqFCPRyknZV4UApEg/E2zGUBdiYSJp4xA76nkz9NxkfzbltvR0fEW3iESPXHQiao63sw9lA1Sy0peOKrt8xzajVOLyfDneT88o2nEm/RCHFId69BXISLHJ3KgNw0kkKJrPz+9QUailfQvcXJYOfepaZnKJBGElcJXa04MHG+5EGHK6+gaEn5xSyaM2Js7irVVoDog3+kYrcvlWNnadjZ65lRu6Wz+cWVoAdx5+4WaTUHNd6GlxyJ5e2bDjCMP5AiUk3+KF6GT7K1K9AV+ezlQ7UohQChNFV3nyZNqY0dvA2i5QekCEpO+jPyWwYj/i
 klTUjzpO
 48T5QYtXS061NkfZUCViUb+Bc6zL9N2UHwT4R/PfDKNMfW/3fNYeg1EYxxik397WqgNsQTfNnc569ZNVtPPwCc28o52iF/OqNMUYi3EIzRbkXlaZseJ/tnPNz3gLc5CqLDkl0WVw5D89qs3tHVVFtvXvRhAQmxtNKsmXWLv3j5sifXvubXUVjeOVQYqKS0rNZtqn+DIRxg2hGHslbbRf61kBEgk/7eEW54M5uf3yLIajROwJeQQxNQNs6c9QlHM6snQXQzlgGjW6cNlA0bcRxR70PkpSwOYyu2JaY6CkTFMKHrimDlHGFFMTB8Xkb1SW7xgUZfUUjxIHtep/somfAq8pUZ19SC4RTAWUCFHvA3BdRug26M3++ZOwflsK73uDih43kvu5+RFBBiFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 04/11/2026 06:16, Weilin Tong wrote:
> VMAList opens smaps with universal newline handling and strict decoding.
> A carriage return in a mapped filename can split a header into multiple
> records, while non-UTF-8 bytes cause UnicodeDecodeError.
> 
> Read LF-terminated records and use surrogateescape to preserve filename
> bytes. Escape filename characters that stdout cannot encode to avoid
> UnicodeEncodeError when printing mapping names.
> 
> Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Link: https://lore.kernel.org/linux-mm/20261101211644.c63a2028bbede0f763f41f80@linux-foundation.org/
> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
> Changes in v2:
> - Escape unencodable mapping names in vma_print() (Sashiko).
> - Rebase onto mm-new.
> 
> Link to v1: https://lore.kernel.org/linux-mm/20261102085419.696232-1-tongweilin@linux.alibaba.com/
> 
>  tools/mm/thpmaps | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/mm/thpmaps b/tools/mm/thpmaps
> index a1a9bc30514f..0e17723515cd 100644
> --- a/tools/mm/thpmaps
> +++ b/tools/mm/thpmaps
> @@ -196,7 +196,8 @@ class VMAList:
>      # instance to receive VMAs.
>      def __init__(self, pid='self', stats=[]):
>          self.vmas = []
> -        with open(f'/proc/{pid}/smaps', 'r') as file:
> +        with open(f'/proc/{pid}/smaps', 'r', newline='\n',
> +                  errors='surrogateescape') as file:
>              for line in file:
>                  elements = line.rstrip('\n').split(maxsplit=5)
>                  if '-' in elements[0]:
> @@ -363,12 +364,14 @@ def cont_parse(vma, order, ranges, anons, heads):
>  def vma_print(vma, pid):
>      # Prints a VMA instance in a format similar to smaps. The main difference is
>      # that the pid is included as the first value.
> +    name = vma.name.encode(sys.stdout.encoding, errors='backslashreplace')
> +    name = name.decode(sys.stdout.encoding)
>      print("{:010d}: {:016x}-{:016x} {}{}{}{} {:08x} {:02x}:{:02x} {:08x} {}"
>          .format(
>              pid, vma.start, vma.end,
>              'r' if vma.read else '-', 'w' if vma.write else '-',
>              'x' if vma.execute else '-', 'p' if vma.private else 's',
> -            vma.pgoff, vma.major, vma.minor, vma.inode, vma.name
> +            vma.pgoff, vma.major, vma.minor, vma.inode, name
>          ))
>  
>  
> 
> base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282


