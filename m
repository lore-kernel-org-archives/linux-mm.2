Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA594CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1EA8E005D; Wed, 15 Oct 2025 13:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2FF8E0005; Wed, 15 Oct 2025 13:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3758E005D; Wed, 15 Oct 2025 13:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D9FEB8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:28:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8656514014A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:28:09 +0000 (UTC)
X-FDA: 84001031898.07.0EA8315
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D252A180013
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:28:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cLYcUCKM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760549288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvVDRnFReodweIyh4vqEswR+ZdFxTXb+n1H2PWseY5g=;
	b=UCLkKQQrBn+zzZNYc6MB9I0vO+ioLHjNWNDUZjPumn0oiCxrs75oRLb4QQOAdMk1RgByo4
	adfJlHG0FBROLvRPJplMSWAxDQa66ZFmU0XQgWSN+PzPRfW9LC3aze67ztOlbTMuW2F2Fy
	g+j3RAcOW/wgJCis941DLbK9Gm43lyY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cLYcUCKM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760549288; a=rsa-sha256;
	cv=none;
	b=XlktzjS4uOMqj2ddMCN/XJfwbGf0Iup4WRRal8XKlDz45Ce5S9jOnaOsq0xLep/u2fdoSW
	h3zsT17uZ8xnvizSOjZYPKIDlbSkiocqYIFM4vTKfsWfoXnMrvrpGHlwZZ4eMsRVC0e6Bw
	YB9nNicNp6GbQeohWx31lUVbH0Hpmfs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F3C949E13;
	Wed, 15 Oct 2025 17:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B3CC4CEF8;
	Wed, 15 Oct 2025 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760549286;
	bh=2/0p/0k/TXO7o16P7A/u4tyNONwtv678Sc1Mfzau9Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLYcUCKM6bI5Mz3l/tIYX/Z8p679bj7v28Kvi74TY7ncPOkHDjSf4kSDNS4Rrv0gO
	 MfF8ObXedzSLW80dEXdPChqCCXcLRHpxhQ6sYCQyL5YhXIij7R6m25TNaY4w/I/oWn
	 GEor+iRGSfQ0uN5vatbPqIWjKlSmdPypIE8CTRamSxuDgJToelhnE5AKSaFiJ1BgD6
	 B0R24iWwCp75s3cU4Or6ZyBpF+8G8eic0/GknwhH8KbJ1bMQO5SWxjKfxapQgHQa+P
	 ZwtVJppb7CxWPrFLIcll1iselKsf67JYLLUZprpMBYL4YisI9hPlE7y0PO6EKSIBU5
	 AsY7Rn1AbrdlQ==
From: SeongJae Park <sj@kernel.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rafael@kernel.org,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v2 2/2] drivers/base/node: Fold unregister_node() into unregister_one_node()
Date: Wed, 15 Oct 2025 10:27:58 -0700
Message-ID: <20251015172759.69864-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <32b7d5d8f0f30d313c3e1d8798f591459c8746f9.1760097208.git.donettom@linux.ibm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D252A180013
X-Rspamd-Server: rspam03
X-Stat-Signature: 7quxtzr5bzesuak6h3jj45wyapzjrqjq
X-HE-Tag: 1760549287-226989
X-HE-Meta: U2FsdGVkX19onwUmAzyz6G8UlAedlv5WNz3nzHVupci1W709eQoElAwVoOEXXihsOts/J0G21UiwvUMErftyRGTnGOkVVtKkGXnqJTk8K/a6gUtOkIeYKOZVvWibW27epJiS7pKju+Yf6XWhtcCzF9YZe4xXIk8wNRqP8+n5ve7P2OgdSJxE6USHV+Gf+t9dWaC/3U3aOmxIlpMfO7NqCFCZ9oUgw0a/aO+84BQ7ZzXtKzhpI4zVktcuFyMFlHRDSQS68xBJq84edAvN+iAwlTAOTS59XWcJ5OhHdsZTo/I+3/gGaKb3N4RPEMF1k2lcDG1qY8HQBZ1rtBPOKDlfSIKnQumyGvZqlIXOAJN01V0GsDjyg6vBKCZJJKbaXFHbQrfvHINFN9LZOZd2BuPhF2WxZFHnF56sJDBySTx68zyIW0diRXFBowl6JjENbg9Q6HvboaSf8NDZLqcP5Bd9I9E8lLIsn1ag15C8+YM3XN8lqTe2kEGCIyvTwEeCEC313guVPG6NiL5Y0fKaA3KUTzkiAOhL05u8BQ1HWS2VJgpjVNmYt6Cq/N1bICwzphOqbIrx1DUWSe5LRJzqZwrTRws78QtlPc44hLN5p0YkBzK7C41BK9Px7wtym3Ckab4kuOgvw0g9prdjE5+wEExNxYYOynmYZ+K+4utuI6xRBg7/TRRaNui+2lZVaAVho5cKIG7PZeX6YsvjuArShPrCALSVKs59TuNueGmHgdTfp3he4ANXtt2EBAjIAibfqfO4qX7QTfxgsxIFc6VZ3RClqreIXo5+VUYfny1S9f8eBgnFgC/wg7FRxlCIYwTrUkjGZjJ3VhvcTWjucrbwKHFoh4QmLsX/34jWOJVaPcsYjApGhdB/4zcUdCazwcpibyVyZo1w4gfXDx44H/8Cfqt8znyZmkO4BSxpIGBlHQ1rRCJiUDfDMAoAj6P7hU6shZGrIKDdvG3c31/ocGuLEZB
 Zy3jySLl
 3L6BwIcsxuwSaDZkkGEEA+h4Lj79yeZWAW0bJSkbK48EInU6fsmDjf5f6NwsElBIQoJZ6DNOd3DHmR1GUDrCM7eY/Q0MkyD7yo256LpX5lzts+p4AgQseOQE5cAfZf/XGKP4setHHdXLYmmTo7Sll2rSWbc2/WVqZcQ75fiZhp+4sTCWau0WphiaE0XtUfTlrQQJuVYVDF6+u8/QB6PRjMOdT/TgTwBLg0L3VBem1UTd0IVr1OK47eih3lbOLeWUkRCftOKXcilTITpU0AHT8E2zIDsYJIdQzLm6oxNNtFvkhe1uYkmTMC7zrY4ZogT1sEBhgPvRHctoHCu9YGLwGvGV+j/+1p1fn2fCOnYyVOGJwZlY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 21:09:17 +0530 Donet Tom <donettom@linux.ibm.com> wrote:

> The function unregister_node() is only called from unregister_one_node().
> This patch folds unregister_node() into its only caller and renames
> unregister_one_node() to unregister_node().
> 
> This reduces unnecessary indirection and simplifies the code structure.
> No functional changes are introduced.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>

Acked-by: SeongJae Park <sj@kernel.org>

> ---
>  drivers/base/node.c  | 38 +++++++++++++++++---------------------
>  include/linux/node.h |  6 ++----
>  mm/memory_hotplug.c  |  4 ++--
>  3 files changed, 21 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 4bcaa8006cd6..758b777dec1f 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -676,23 +676,6 @@ static void node_device_release(struct device *dev)
>  	kfree(to_node(dev));
>  }
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
>  struct node *node_devices[MAX_NUMNODES];
>  
>  /*
> @@ -924,13 +907,26 @@ int register_node(int nid)
>  
>  	return error;
>  }
> -
> -void unregister_one_node(int nid)
> +/**
> + * unregister_node - unregister a node device
> + * @nid: nid of the node going away
> + *
> + * Unregisters the node device at node id  @nid.  All the devices on the

Nit.  Why two spaces before "@nid"?

[...]


Thanks,
SJ

