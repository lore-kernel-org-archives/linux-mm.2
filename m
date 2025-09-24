Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 107D4CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 19:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45BEC8E000C; Wed, 24 Sep 2025 15:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C038E0001; Wed, 24 Sep 2025 15:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321DF8E000C; Wed, 24 Sep 2025 15:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20C3C8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:19:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E82AE1DA170
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:19:31 +0000 (UTC)
X-FDA: 83925107742.30.D076F83
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9D83D1C000D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:19:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758741569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0T0BEn3CGJdLUo/alIU+i1QAr4lyYS9YdnkHR5OSRG8=;
	b=xiEtzTLPFAijlehC4bmDqSWq1u+ypWUya/3+1tqDFuxyQVqOyq5pO6e8LZIS2HexF2Axvd
	kQZVoxLE+grZhPLFVBnJMnXoK5gYLYdDxINB3tzqyg7hfg+xWt0csl923TwWtS4f8PMkJ9
	WBinMAPoitYJi8zEf0AqhuJ9wW7TlvQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758741569; a=rsa-sha256;
	cv=none;
	b=YTsPKehvU9Z+7eiwh1Icba0hced1F41uboCXq7XoIQbv3cVoEhCzT8WqrXNhb2RNL9SWiP
	AXDsfnwL0F1wEM258+pcPWRAP2A+DpfWqFhrl+qDbcm8tiGYLMR0b58YDiKXkmyE135lBU
	BnHjx8/5ot5v7DTEpikBU41Ozv7cRI0=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cX69D2dJ6z9sRy;
	Wed, 24 Sep 2025 21:19:28 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nqpn_EP-cTuc; Wed, 24 Sep 2025 21:19:28 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cX69D0pt8z9sRk;
	Wed, 24 Sep 2025 21:19:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id CC7DE8B76C;
	Wed, 24 Sep 2025 21:19:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id edNE7oeRg5Qo; Wed, 24 Sep 2025 21:19:27 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 135518B768;
	Wed, 24 Sep 2025 21:19:25 +0200 (CEST)
Message-ID: <fa2272b9-13f2-464f-bb95-72fd31f1dcf9@csgroup.eu>
Date: Wed, 24 Sep 2025 21:19:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] drivers/base/node: merge unregister_one_node() and
 unregister_node() to a single function.
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Danilo Krummrich <dakr@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>
References: <cover.1758736423.git.donettom@linux.ibm.com>
 <c99d97e253378455f1b3b7bec5b0c830d4e73074.1758736423.git.donettom@linux.ibm.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <c99d97e253378455f1b3b7bec5b0c830d4e73074.1758736423.git.donettom@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9D83D1C000D
X-Stat-Signature: tapf19sdb8xj5xuqkt483rs5nc5t7zh9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758741569-923939
X-HE-Meta: U2FsdGVkX18pjBTlSkn6MknIwqwI7l00AeYTQixY9e+b8W+9muesGVGzRg35ZaH0iCqdg+wnWyoB+cVjaCeOowyunRZFZwp26rldniwkjtyaw8o/OCHh9SJH5X2q4IHVI+8cvW5FDlQJ1qfzGPkDNISaA/QlcOro6HzwQXWDT8WDyeKJt7odPQ3DJYH6GaPkl9aVJILFalmiyInNgNH/BtiKJRqbmIMPOyfeZgkIsiBiCF6+qpYY+srxer1JHbHZZYKvtnkANECoZw5qDOHTrfOTvT0DmwkPf3QQQHF+c18kQ36w1+VqCC/3YpuuhUSJWqpduZY1kj6xgESzEBMcTuGzdQMoKjJilTBuoSGAD+kUt6mXO2cmQk0CSyQ7XrqlOwpsOIV5LQf2kUqP/OchiOduPc66Dg5NFbhrIRw5nWI/erkch0dnjdrioxbM5nw/0iTVx2JvdDHB+GIWNnHiMK/khE0/5VosxMMVDKuw4oaWKlQmk46Ot6jVB9YbREvVsPk/Y1Ph46af0D8Uadxz3Iuby0DVoXxohf1OSbOPqizdNsiXUw0xgt1XbhFHTetiYzlHNUbRSwrJvSNCtAT9t3gCFTbQPVRc3QDPFxL67iG+0iHcSStFROGIlz6J7pHkuGjTc5V9YYnQnwp1ctO/vaGYjA+zVIk5AuIdGNe77MLBAOLXOuMUVJ9LDznElO44CrRX4P31G6gZVEd2yvLJKjgEQV6lTOq3KV5sIehZmJr/Yy5T7bzVykinp/5R20bTqB4Wlp4H2MgvbxiWRn5lca5z8k5fx97LjZkIhSZ+8jQmmENyK5hZF//+cplr96mUtRkQeoDa8/wKamC7UZxhzC0u230nB+0YvwRW6WkEG+d49CQxrA2gEZWmabBpCdiH10nCDsw7zm9c1cQSMI2VAxOhKiNVeJdUpmpvQBmCIZwSN9I3msiDD7nB8i0IWH2TOtvGvJuUcx9+fpjRqEV
 rQn6Q1ux
 3Yjx9Y3T/d9qy95uI9ZC9hnVFFtApFE99RbeWpT+JBgfuHWNXjiAOX9HLkStiBNjFLg8TEdAxfybxcO35VhaRjhH9ovYJvd4OVXB94/2I83uJdkPFTrZ+FuAElXDDNqhdAQqRGu6s0TAj+146ahJ/QEbXod5p6K3pSMUUoAEYv8IL7Rygs32XoierDAOavtpR/I46BziUmCSbPPokYP+ARVH3kp4YsjboAj+jLUPguQsyOTcZJ5WLz4+s42mvS+m18cypDlQixIlXxIlKq/yHpTWJtHSgUHUGRKDfOhIGEUdWC2sE6q3gB6RZ1mWHAwfpSD7T4Ce+6Xi3NwpuUh2bG7BWOVh8T9hATN8k7JmfjVDUKXk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 24/09/2025 à 20:40, Donet Tom a écrit :
> unregister_one_node() and unregister_node() are small functions.
> This patch merges them into a single function named unregister_node()
> to improve code readability.

Same comment than patch 1. It is not only because they are small that 
you merge them, it is primarily because unregister_node() only has one 
caller.

> 
> No functional changes are introduced.
> 
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>   drivers/base/node.c  | 37 +++++++++++++++++--------------------
>   include/linux/node.h |  6 ++----
>   mm/memory_hotplug.c  |  4 ++--
>   3 files changed, 21 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index eab620e29c78..d460c1675c77 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -638,23 +638,6 @@ static void node_device_release(struct device *dev)
>   	kfree(to_node(dev));
>   }
>   
> -/**
> - * unregister_node - unregister a node device
> - * @node: node going away
> - *
> - * Unregisters a node device @node.  All the devices on the node must be
> - * unregistered before calling this function.
> - */
> -void unregister_node(struct node *node)
> -{
> -	hugetlb_unregister_node(node);
> -	compaction_unregister_node(node);
> -	reclaim_unregister_node(node);
> -	node_remove_accesses(node);
> -	node_remove_caches(node);
> -	device_unregister(&node->dev);
> -}
> -
>   struct node *node_devices[MAX_NUMNODES];
>   
>   /*
> @@ -887,12 +870,26 @@ int register_node(int nid)
>   	return error;
>   }
>   
> -void unregister_one_node(int nid)
> +/**
> + * unregister_node - unregister a node device
> + * @nid: nid of the node going away
> + *
> + * Unregisters the node device at node id  @nid.  All the devices on the
> + * node must be unregistered before calling this function.
> + */
> +void unregister_node(int nid)
>   {
> -	if (!node_devices[nid])
> +	struct node *node = node_devices[nid];
> +
> +	if (!node)
>   		return;
>   
> -	unregister_node(node_devices[nid]);
> +	hugetlb_unregister_node(node);
> +	compaction_unregister_node(node);
> +	reclaim_unregister_node(node);
> +	node_remove_accesses(node);
> +	node_remove_caches(node);
> +	device_unregister(&node->dev);
>   	node_devices[nid] = NULL;
>   }
>   
> diff --git a/include/linux/node.h b/include/linux/node.h
> index 4dcf876cd0b4..d721127964b3 100644
> --- a/include/linux/node.h
> +++ b/include/linux/node.h
> @@ -124,8 +124,6 @@ static inline void register_memory_blocks_under_nodes(void)
>   }
>   #endif
>   
> -extern void unregister_node(struct node *node);
> -
>   struct node_notify {
>   	int nid;
>   };
> @@ -169,7 +167,7 @@ static inline int hotplug_node_notifier(notifier_fn_t fn, int pri)
>   extern void node_dev_init(void);
>   /* Core of the node registration - only memory hotplug should use this */
>   extern int register_node(int nid);
> -extern void unregister_one_node(int nid);
> +extern void unregister_node(int nid);

No 'extern' on function prototypes.

>   extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
>   extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
>   extern void unregister_memory_block_under_nodes(struct memory_block *mem_blk);
> @@ -185,7 +183,7 @@ static inline int register_node(int nid)
>   {
>   	return 0;
>   }
> -static inline int unregister_one_node(int nid)
> +static inline int unregister_node(int nid)
>   {
>   	return 0;
>   }
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 6c050d867031..94a8f6e8811a 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1596,7 +1596,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   error:
>   	if (new_node) {
>   		node_set_offline(nid);
> -		unregister_one_node(nid);
> +		unregister_node(nid);
>   	}
>   error_memblock_remove:
>   	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
> @@ -2201,7 +2201,7 @@ void try_offline_node(int nid)
>   	 * node now.
>   	 */
>   	node_set_offline(nid);
> -	unregister_one_node(nid);
> +	unregister_node(nid);
>   }
>   EXPORT_SYMBOL(try_offline_node);
>   


