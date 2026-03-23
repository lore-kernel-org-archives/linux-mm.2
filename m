Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89E2EC01AA
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496286B0089; Mon, 23 Mar 2026 05:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4463E6B008A; Mon, 23 Mar 2026 05:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35C1C6B008C; Mon, 23 Mar 2026 05:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22F436B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:14:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEC9C1A0A0E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:14:45 +0000 (UTC)
X-FDA: 84576767730.21.E5D68B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id F0347100007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:14:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UtV2YxF+;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774257284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTuZQB9f3kkd0iQ+rmQ7wLMgwGPthR2k60jmOHO4iGo=;
	b=VZ9lOOJkFY94iFVSA1m4hcA5N1h3dyFDc6hCxknVc+lvs9E+KOJmzKH/6v86fLamApbHiP
	avpRHgpibWaXXm4io8E3HzqxOlXVCxMsN5ghIN9NN93hEpqYVMB6azFFzg0ASbb8SbYvah
	Y7EjSkyYREQ8uv0vuQ2EE6wSQmuuzGY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UtV2YxF+;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774257284; a=rsa-sha256;
	cv=none;
	b=eVNxs5ND7Ivt3nsoCBKsCOOv360tXHpjbFrTrHIFEjQ5NUXRzs87uNgn52HPa6dlW46Ffl
	6X4z3R9uAKmnrjD5QP14VOcGC8gE3qo8d9Ad6m7oyb6Gy6j4ozNBP3TJuk2iEa9aD7ZrdA
	3VpSGdCpYrATD5EkCJUJ8Z9Y6FxALeM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DECA600AC;
	Mon, 23 Mar 2026 09:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680BCC4CEF7;
	Mon, 23 Mar 2026 09:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774257283;
	bh=i/HEIuPhbXVoJaiS+cdZHGkXXDM13SX7eYM4Khq7ZPI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UtV2YxF+6zPdnrXdMwQl0Qq/MhwGXUaUeAvWvppN8bQhJGsL5bX9qze4DRk/Dkfzr
	 qQZNLP/etFHe4T0arPycR19z2G9dHwDr1VWblcGRnt0O5z9Ne1cXmenlt9bKWALfb3
	 Y8FwBSRL8QIaVSuwlMy+lOERQtLTWZTIUNxNw08MZfgVLPOQuAPBw+OzTdWP8kNcNu
	 4zzJ6Q7Yy8LaO4FQZ5pBMOUdXppQUvkc0hYxzLxQ0ONGUabNdqY0Y7lhoHHyI7aaVf
	 u+6CZ7nfk9pfuVcmOXDDhEZ3iJHhMIMOYZttc0JDLFmXERktPK0PQLnO9HEz46NJtK
	 isQ7yWrHWzV5Q==
Message-ID: <5c6e3c1a-bae3-4997-b02e-135374d1d6f8@kernel.org>
Date: Mon, 23 Mar 2026 10:14:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via
 debugfs
To: Juan Yescas <jyescas@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier"
 <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>,
 android-mm <android-mm@google.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 lsf-pc@lists.linux-foundation.org
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
 <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org>
 <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F0347100007
X-Rspamd-Server: rspam08
X-Stat-Signature: 3q9sopszo9nbnxbbftf6gkekbbmdbi3n
X-HE-Tag: 1774257283-960620
X-HE-Meta: U2FsdGVkX18hFli2Giq4sdUjFVssSZ9K1RhS9E5adleyZNYhyIzJC9BLjDKjZ4+KXcT8sDahtTeAebKvljs/ivZjh0M1ZhyhPRXHt6BpZzTZ2xQKBjsFVyFp2A+diM6DLuYF4iCvhF0X99Z2UziamXeQ6yigMnSTCR/BHjzvtCe46ZNubVI1VDDv6Bg9Je1Kkox3H7yRiZqR0EPFS+pCsDHtVfEaT74P8GJ8LUg22U0kgJHmMx1nxK58Hrwnr8iiFfdDqy8VGG2dQImLH6sw0Tjiy1beb0WPSd4ipyaxpCbprH6NeteE6Z7b7+6OiOEWH9AeqowPEMWfzmVPlcTlJcj4iL9XnuVPXOHs7nZmOAnK77QMpxTXPp0sxOOQtZhmRMYjhhNFcXw8Ru92JosU5Al01RhgPUQB70YGH6dJresdys1kqKZGIt8nafOb8/HgH3eHoSkiugCiv/dHhImlG1Gw3NxE0AZGNtof3gaprRPyjyoE2Rq9I8PXm0TGbhsTEDOZbaWZd72oUzXI76zyg/XylqFr7QGSzvUsvs6BVAqdxvMzv77O5d31wMSwuT63BuAzu/M5uoTTXb7qJk53ZP4zRr+DL2whc/OIHIWEyX6vSNCyVf1EhvYamgkYU2iAGvwF4Stp1cemixTtGBEpAlea3nUkUu6vHv4Dno4V9PN1fBvDLVA46gcccaFkLd23dB9hXsAuEV5+2qrBicTcafeWyfHwpCRRnm1QDtFHp1s0ZPZdAWcQ2caJY7x+yyqUvuAdd0cy96I97CpQdvoy0A6OoVTulDmHEzJFiCwWmHnt3b7CnB/hyjgtvieH8Qo5Fq003SIe0dVKQG9n7VJJViqY6fUv/xwNy+nzvkcb2btrejGeOCbs7K5H7NsMyAoPg+3XevmTPqTF+lLrtkGqzZUCeDFbipIh+fM0ay2ymnjBo6t5IJRgdb99UFZ3POIZNpX2FWk0aUTUcOC9yv6
 Q8yWViLR
 zwavNHE9Dq0YCEv484+3bfVudPJSmnZg1oj7lL4DO7Rg3c8dEyTu4g8L0Bv/1nqWbwmPiiQKJXuTq3XDuJ3nc92xu28ISHqq0TwpMgmYspQVdykaR+JhgO3Jbmnj/C/kNAeLoiOWfq0GlFAva+etj+jIAh27DIX9xcm0bR8bTzQUD9TlYKqYTHJFDK+GXB5AZ3qk74eHfUOZjw9Qn3LNpWYBPRHBtvErHX6lyjJarOjkndJb3t5JoSsx8cmK95ZfdBHX1VwjIr+7r1vkj7y0f48QowBWdWk168gz4Kb84OiJvcR5idprYTiv23w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 01:56, Juan Yescas wrote:
> Thanks David for you comments,
> 
> 
> On Mon, Mar 16, 2026 at 8:52 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/27/26 03:42, Juan Yescas wrote:
>>> Hi LSF MM organizers
>>
>> Hi,
>>
>> I'm late ...
>>
>>>
>>> I would like to propose a discussion on improving our ability to
>>> reproduce complex memory allocation and reclaim scenarios, and solicit
>>> feedback on a debugfs-based testing interface to help trigger these
>>> edge cases.
>>>
>>> == The Problem ==
>>>
>>> We frequently encounter complex memory management issues in the wild, including:
>>>
>>> - CMA allocation failures due to pinned MIGRATE_MOVABLE pages.
>>> - Page migration and compaction failing during reclaim.
>>> - Excessive reclaim loops triggered by specific workloads.
>>> - OOM kills.
>>>
>>> Reproducing these specific memory states for debugging is currently
>>> cumbersome. For instance, consuming most of the available
>>> MIGRATE_MOVABLE memory, or forcing MIGRATE_UNMOVABLE allocations
>>> specifically from Node 1 and Zone DMA directly from userspace,
>>> requires writing custom kernel modules or relying on unreliable
>>> userspace memory pressure tactics.
>>
>> I'm wondering whether an OOT module for this purpose would be sufficient?
>>
>> IOW, do we really have to have this in the upstream kernel, or could we
>> have a public OOT module to perform these allocations?
>>
>> Then, there are no worries about API/Extensibility etc.
>>
> You’re right that going OOT would bypass the strict API stability and
> extensibility requirements that come with being in-tree.
> 
> However, there are some symbols that we would need to be exported in
> order for the module to compile.

Reason I am asking is because we had similar discussions around memory
hot(un)plug in the past, where we decided that an OOT kernel module to
simulate add/remove was a better choice than exposing weird APIs to user
space.

Which symbols would you need? I guess we'd want to call the buddy by
specifying node+zone+order.

Is specifying the migratetype really relevant?

> 
>> Or would you want to fire up this debugging on a production kernel? I
>> would assume now.
>>
> 
> Yes, that is actually one of our goals. We often encounter
> "heisenbugs" that only manifest
> under specific workloads and we want the ability to stress the memory subystem.
> 
> For example, if we want to increase the unmovable allocations by 16 MiB,
> a 4 KiB kernel, we can do
> 
> $ for i in {1..4} \
> do  \
>   echo 1 > /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Unmovable/alloc

How will we handle unmovable allocations ending up on movable memory
(e.g., ZONE_MOVABLE)? (e.g., allocating from ZONE_MOVABLE)

Also, is there any reason why we can't do it similar to hugetlb and use
a simple "nr_pages" variable, that can be set and read.

Why did you decide to use the "handle" approach?



>  \
> done
> 
> And this is way more convenient than writing a test driver to make
> only unmovable allocations.
> The same apply for the other migrate types.

Right, but the interface you provide looks like it would allow
allocating from movable areas etc, and I am not sure that is generally
helpful (or adds more complexity to handle).

-- 
Cheers,

David

