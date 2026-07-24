Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96506C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 13:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460DE6B007B; Fri, 24 Jul 2026 09:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4115A6B0088; Fri, 24 Jul 2026 09:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A246B008C; Fri, 24 Jul 2026 09:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE036B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:37:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BBF08033E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:37:13 +0000 (UTC)
X-FDA: 85023771546.03.2AA2F41
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf21.hostedemail.com (Postfix) with ESMTP id 65C3E1C0002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:37:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UvQ7Evnd;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784900231;
	b=XFOSC7E87c6Ks25GOGrtXPRA+uaDxdw7zImWJAGCQ7OsO05Xz874t3bzU4EuoWPZa+cPkI
	pr8OhZKDtclrcrMQN/8kLZa34RjjdhLTB4qKXs/tE1A9YETNJiYokzXnjCJhWXhLhAVZZr
	YLZiEml96hPQzPZJfFvvAQqxbROK2j4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UvQ7Evnd;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784900231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/FxFds0ZblJiTDVn0Zh6YSzNFtgG6KSsc6BX2Vp7N0=;
	b=n+zvb9KCG8FcJ6ALenaHqRRUE4ZfUER+tat1oDvLeztFDK8k6ecuNY29MJvZvgiWHPqBSn
	fkEs3eGOQ+GsEWhuZsb3sQm9u0hBY6EOVoOJwmkYHT3HTKADzIupm+smoMyXyUgGnsMpu4
	H+O5NmBTx6ZNqqmZ/ThHySY2BO2p6Zo=
Message-ID: <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784900227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6/FxFds0ZblJiTDVn0Zh6YSzNFtgG6KSsc6BX2Vp7N0=;
	b=UvQ7Evndl12aryBj5Gzh/4Kx4IFxjvJ4rQR7z7ZeZ02IkJcBysdcs4RGKKa4/VtIk/MUN4
	kFv0UzKogYSnjvY8paSxOYiT0jsEqzPaZPtCX7Fha6cYM3qT2NMr9omxqoVR6rqLt06FcV
	aqyG0djpQWd5Myh9Rdt5ZWa+1GWgLE8=
Date: Fri, 24 Jul 2026 14:36:59 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] mm/parisc: constify ptep_get() argument
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-4-pfalcato@suse.de>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260724102017.141532-4-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 65C3E1C0002
X-Stat-Signature: 1pcc7985pn5a6w4rf46up4ay4aqhn4td
X-Rspam-User: 
X-HE-Tag: 1784900231-944693
X-HE-Meta: U2FsdGVkX1/XPujTP/yhhB1O780UkQpsMg+05pPq7Ts9Fh9XPZo2DrWZgdTfXCp8sI5ZiNW3EMe6fc9MDRnymWvfltewaxZFCZG5g4h3X8APzmGKZxfjUNcB66K5Y/l69lfAP7MPdaY12ENTIVq3enCb7z3hcZKnzXqQfeQa58Di2OPRB53ilC3jTe52SuvA3PT866MzLJ9a5OOKkpfESsR/JfsT/eRvdiXOXoGAKLLE43AL9GQjigE0qA55mWJH5ocSS6TcWUP7bjedbdyNR8ikQdzFz3IjQkRVBSwHp38NwOQ2umM2OHeADrWOesNMCKtq/AV5vFz+F3Fg9m+SXaet+Njv81t9AMA0IEz3sFWlN3mphtOzy6+GPbpDrvIcsghs4Ab6WyR0PlVJhvz8PnIuHU0vdzZ1Ytu+HEI3g3PoXEmbdYFmUYZB72QClWjVvJ+NWJ4EY/OHyZ5hCQvT3jy2LhuW+weadaT/MuLMlUZfPP7yR7g0g5BEjj1ULVODWXxdLuQSUpZxFeukWSzIJozbmEsKv+LrBYgj6+wrZDT+yw9XD9nkyoWnOsOW3hp+/VOLBqcEQb8ywH99gNOfRMsdTNe8+DXpGyZ7w9+Kl8tVY5moEpZEQA3SsBrZTadiHgCocysF6Xi2lBIXqYkc/FrdEj1llWq3tRmFmaE5pnMX8v7H8IcZJlOno7cL1He4DljTL6IYSq59FKWDrHWt0eUOeXONbOFDEdaYtz4nPq5jLdf6iqWuU/vxHH6QFV4uhGSuoDbv4Mu2z1F3ZIQy+8AvI7hbcJnNj9jV3dN/c23r/2lbAiEj5Ta8NhdlpObeoHckK6sAd/prx+k5QUiX2h8u4mmys/bCJSC0Yayw0ENdwP8saNCyoh7M1VyNKFOkNcIAaDZCRfKjgBQhU5ZlhkayLKzJUXcTPLtsRUGilQ1Fgv8LvyrV36shCaPwPuBtITB/TkKXQf8zFeDvCdy
 I8k4Du5m
 uF0FZxUe1aqBGX1JL5HCg6nisX+A+bU7Mp5nE9ZrDamHLbvyl53gLwAZ4SVNtKR0UJajRLR8KFoNt6BbNbtznMFXaJPMQDPGj7Z9TV8PDxiT/xjw8FaYChuTYoFnQE49VQ9EA938RCSM5r4OHu2sgyn5UUBOwnobOMW0FBPg/HVrmASVWH0Fc3+WwsUBEGa8MMcZwqvq6Vq6orYOnFagGF674Ut3Xu0+NiyH6GxW/ffXk3zoVw6EuXprGPM/ZeaKs0b6Qn5f9wq7ngWIPr9JYi/h11tRLeDQhlIteDDUdCkS2UJQkEFaRbPYtS9C8XByOssnY5ZqBYuYwzrhKqnh6uypXSQWweIyqnjKPL0FAw3GUgdo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/2026 11:20, Pedro Falcato wrote:
> ptep_get() does not need write access to the PTE.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  arch/parisc/include/asm/pgtable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
hmm I think you might break build bisectibility if
you separate out the patches, you should squash patch 3 and 4,
with patch 1.

