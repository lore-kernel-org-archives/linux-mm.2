Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B16C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 13:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C8C6B007B; Wed,  5 Aug 2026 09:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD1F6B0088; Wed,  5 Aug 2026 09:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3DE6B008A; Wed,  5 Aug 2026 09:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2580A6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:12:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2299FA04AF
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:12:19 +0000 (UTC)
X-FDA: 85067254398.05.92657AC
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.76.78.106])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4723FC0012
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:12:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of dzm91@hust.edu.cn designates 13.76.78.106 as permitted sender) smtp.mailfrom=dzm91@hust.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785935537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JN58H+mv9VIBLLtuPiRzjyJ54hny7MkFV6JxtiRRwiE=;
	b=gx45Yq+/MRZxvOXfeb/6cdHSOns645IKWWkDNLwq9OyZ7Ecvm/4pD5O0lHaOSjC/S39TaM
	mtCCJxOeedDJ+5ZsuzBT/FI0QHWSa9tMl9KbT/OUOT9dR+Ul8Cy+J6G9nYvBIc0P/4RSLG
	0omU2qU2ghkDAIFJWKTFpJfFH+KAj3E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of dzm91@hust.edu.cn designates 13.76.78.106 as permitted sender) smtp.mailfrom=dzm91@hust.edu.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785935537;
	b=HXNPOwXwKLGe0DH3jz4DsiZuInHaNRoMikBTxsR4vDit2qq1jDKnqKes5r+X9iTDz3+WrD
	upjdXRpjEzaJm2GJ9J6p+hoeLF7Svaf3PF0sc4/jWHEgAcnEoRPaePjVeYpP4Zu1et9i6e
	T5uHi9t56GeV7xH9m8ZkYdbqpodEVz8=
Received: from hust.edu.cn (unknown [172.16.0.50])
	by app1 (Coremail) with SMTP id HgEQrAAHDiqfNnNqHN__Ag--.63414S2;
	Wed, 05 Aug 2026 21:11:59 +0800 (CST)
Received: from [100.81.40.43] (unknown [10.12.191.55])
	by gateway (Coremail) with SMTP id _____wDn71ebNnNqGPIaAA--.37874S2;
	Wed, 05 Aug 2026 21:11:58 +0800 (CST)
Message-ID: <328d031a-14ae-4cc3-a200-462094f0e2e1@hust.edu.cn>
Date: Wed, 5 Aug 2026 21:11:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksm: update comments and docs to reference folio->mapping
To: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, corbet@lwn.net,
 skhan@linuxfoundation.org, alexs@kernel.org, si.yanteng@linux.dev
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
References: <20260805105927.41987-1-hongfu.li@linux.dev>
From: Dongliang Mu <dzm91@hust.edu.cn>
In-Reply-To: <20260805105927.41987-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:HgEQrAAHDiqfNnNqHN__Ag--.63414S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWw18KryDJryDXr47ArWxtFb_yoWrWr4kpF
	W8K34Iqan3Zr1Fg3y8GF4jyF1UZwn7Ga1jkFn8K3WfZFn8A340qr4Ig3W3tFy8ArZ2kayY
	qFs0kF909a4jyr7anT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQFb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
	v20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vE
	x4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAaw2AFwI0_Jr
	v_JF1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF
	0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0EF7xvrVAajcxG14v26r
	4UJVWxJr1lYx0E74AGY7Cv6cx26r4fZr1UJr1lYx0Ec7CjxVAajcxG14v26r4UJVWxJr1l
	Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw2
	8IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFW3Jr1UJwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07bIiiDUUUUU=
X-CM-SenderInfo: asqsiiirqrkko6kx23oohg3hdfq/
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: e67pihrxb6f5nw6mxw3tfcn3b3y6ydcy
X-Rspamd-Queue-Id: 4723FC0012
X-HE-Tag: 1785935534-135886
X-HE-Meta: U2FsdGVkX1+/zPq659BNEM9VlDQp9ujPDUyx7MQsiAO5O/Hl8Zk/NI2Ivv6oVdCmcPotBpEr0kj4ZQR4710ZtDYjNsC+2iJkSKzPSN1mbpV1Rx8GBmHdi6tco0QBBotLxMok2vcglu+mUlP73gvZHDHeQsQ/Vhl33Sk22SkaPb3jN7FVs+7hlpz7aMN4QLlYglrvNkmX6w8xlGcdyzILVdSZNNvzFjl0tZvGlTsPotLENFoDx4e1Acl6WrcUwVdSsa5NodzzLGlCcdysJgqjsKd9gbrYkbaiaw2BDj12usD4+ucCTrsTUBSEqLS5KYmTObhTSsYumxomVmJ0p8vAr/ePl8eQO+fVqSKfjbAL3TxULwRFAOYWkRph/zRIsObKhwo1BZYHGhtnIGpwtwJqrQ4aJHOvAqc0OZIA15Qd3SfRGpfjGMX2/pS6nBgdqVX6Qnr0V2I/ULb4v6d3/58kBzfNBHpeEJ8WGwRMCALml5mz5QXkP1yBv8PcfAULsI4Ui883gz+Xz0hHXsnO+w0ExBSg4h49OF/hOrVqg+oKI0rXd617Mm9H11EKokBIDz9qgf6Gtd1gUBv3wkI/oBS5vVzCGKRp2T1D2fgtQVDMqrk3y26unYmb9yVNASkKf73NwKJ8FqoA9Go4FXxO/16cHQJuGhBaHQBieHjd07vrpjrZArGaXVKT6g4wFMPHX/v/qFO/9FPsBRvp/ZX5O/Yd+0h0P6TRxWXkuBjw9PKA7VG60bRgGQLSw3KkoOStj04XFi8RV1gOiPYUL8dkVFw9yNDJ2P05raM7wrjN9ehy3hWUPSzBL5h+5VQvicYe+DIcUvJZNht7H7lmfpiDiXYlHNjcRK1Lf9TrrFMJkbcZloBIIx4igtkvu+NtJwRKE48J/aFvB0f03HQi5fQ0Xj8ErphDXR3eZmx9dTBcvjRYNusbHeKAMOBsuwH+7zASi0XGxSx0rhoeF+qel/Cj0K/
 CMAnKx9j
 arzfjZIjFeUIRCYqIeDD5FmPpfC2OqH/DvZL4FoIumMPH4nTT8xJ0pzVuHsbs3xM1naUy9rqD9ZsUkecDSmcHL6uCs3gSJp1wDk1/kA/PJ0Z1bFRm4CLMu92vBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/5/26 6:59 PM, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>
> The KSM code already stores and checks the stable node key via
> folio->mapping, but the comment in ksm_get_folio() and the reverse
> mapping documentation in ksm.rst still refer to page->mapping.
>
> This is a pure wording update to match the folio-based implementation.
> No functional change is intended.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>   Documentation/mm/ksm.rst                    | 4 ++--
>   Documentation/translations/zh_CN/mm/ksm.rst | 4 ++--
>   mm/ksm.c                                    | 7 +++----
>   3 files changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/mm/ksm.rst b/Documentation/mm/ksm.rst
> index 2806e3e4a10e..2b4f72f1f953 100644
> --- a/Documentation/mm/ksm.rst
> +++ b/Documentation/mm/ksm.rst
> @@ -24,13 +24,13 @@ tree.
>   
>   If a KSM page is shared between less than ``max_page_sharing`` VMAs,
>   the node of the stable tree that represents such KSM page points to a
> -list of struct ksm_rmap_item and the ``page->mapping`` of the
> +list of struct ksm_rmap_item and the ``folio->mapping`` of the
>   KSM page points to the stable tree node.
>   
>   When the sharing passes this threshold, KSM adds a second dimension to
>   the stable tree. The tree node becomes a "chain" that links one or
>   more "dups". Each "dup" keeps reverse mapping information for a KSM
> -page with ``page->mapping`` pointing to that "dup".
> +page with ``folio->mapping`` pointing to that "dup".
>   
>   Every "chain" and all "dups" linked into a "chain" enforce the
>   invariant that they represent the same write protected memory content,
> diff --git a/Documentation/translations/zh_CN/mm/ksm.rst b/Documentation/translations/zh_CN/mm/ksm.rst
> index f0f458753d0c..822c7a289671 100644
> --- a/Documentation/translations/zh_CN/mm/ksm.rst
> +++ b/Documentation/translations/zh_CN/mm/ksm.rst
> @@ -31,10 +31,10 @@ KSM维护着稳定树中的KSM页的逆映射信息。
>   
>   当KSM页面的共享数小于 ``max_page_sharing`` 的虚拟内存区域(VMAs)时，则代表了
>   KSM页的稳定树其中的节点指向了一个ksm_rmap_item结构体类型的列表。同时，这个KSM页
> -的 ``page->mapping`` 指向了该稳定树节点。
> +的 ``folio->mapping`` 指向了该稳定树节点。
>   
>   如果共享数超过了阈值，KSM将给稳定树添加第二个维度。稳定树就变成链接一个或多
> -个稳定树"副本"的"链"。每个副本都保留KSM页的逆映射信息，其中 ``page->mapping``
> +个稳定树"副本"的"链"。每个副本都保留KSM页的逆映射信息，其中 ``folio->mapping``
>   指向该"副本"。

The Chinese translation looks good to me.

Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>

>   
>   每个链以及链接到该链中的所有"副本"强制不变的是，它们代表了相同的写保护内存
> diff --git a/mm/ksm.c b/mm/ksm.c
> index ab1fc59424e8..4bde9fd8d44e 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -959,10 +959,9 @@ enum ksm_get_folio_flags {
>    * seconds or even minutes: much too unresponsive.  So instead we use a
>    * "keyhole reference": access to the ksm page from the stable node peeps
>    * out through its keyhole to see if that page still holds the right key,
> - * pointing back to this stable node.  This relies on freeing a PageAnon
> - * page to reset its page->mapping to NULL, and relies on no other use of
> - * a page to put something that might look like our key in page->mapping.
> - * is on its way to being freed; but it is an anomaly to bear in mind.
> + * pointing back to this stable node.  This relies on freeing an anon
> + * folio to reset its mapping to NULL, and relies on no other use of a
> + * folio to put something that might look like our key in its mapping.
>    */
>   static struct folio *ksm_get_folio(struct ksm_stable_node *stable_node,
>   				 enum ksm_get_folio_flags flags)


