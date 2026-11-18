Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA09160A260F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhxdXmPN
Received: by kanga.kvack.org (Postfix)
	id DCC0F6B00EF; Wed, 18 Nov 2026 10:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4146B05B1; Wed, 18 Nov 2026 10:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA306B05B4; Wed, 18 Nov 2026 10:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD4526B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:21:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 203ED1607D8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:21:51 +0000 (UTC)
X-FDA: 85448604822.19.448B783
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 660B720009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:21:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhxdXmPN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pusLzVCwTtItlUsOXlNfTNFkn5iND1btK/l3K/MI9q0=;
	b=SXlIMX/GMcV6dE4TosHT8GmyvgzDtw3oiPg0ryUQW2dCwDx9q09ynD7nG7zqdyt1pbF6oA
	f+UufsX2A8lMVMI1XIIHod8L7IiUPgI31ks9Q6gl3Bj4nB6GiaH1KghY5VtLOwICQM3SyJ
	3O5KGDco26Xsma8Z5FQZ6M/h+L3F70I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhxdXmPN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015309;
	b=wBllVZdaHLHfbSG8mLokK0Vw+d3m9MvnEtkdUgsCfHBJcOdDX1zuTcX3NTD6bSae4WENhH
	WoZaPrKQQ8Siw6UjzIpJXHo5j/Ff48LzFb3yIskNaVctIxFqTAVMI6H3VkYn6uvleNpE4d
	yG8AJYa+M6hyvBSBD9SvRq4J+t7aXdg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E31F962399;
	Wed, 18 Nov 2026 15:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB4F1F000C5;
	Wed, 18 Nov 2026 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015308;
	bh=pusLzVCwTtItlUsOXlNfTNFkn5iND1btK/l3K/MI9q0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mhxdXmPND91KvmwYa/00zWlHUeWe3eBJp1Uu+QAWUmmmsmOrW2QdnqCcMvEehsGWV
	 5joEKI5gJKMnsktMlasDA95qgr5UDSHclNy88PTvDWlHIIw+4cuRZpAaQEtUARrPQo
	 6RZQXjBIBWTO9xa0qk5clO3PyG2roHVVgYyFQJ4gFpZ81bTiYyylkCM008yiwEn8gG
	 A7Gvy0G8eeJkFAze80YQkDtA1+5dWx31WJ6Oho5yzD05WrL1rPKlhuCTfVkLA3YYrw
	 m+CnHCkPxsXGbRXiTYy9VxVzS0Y5y20tmQnvBbMX2DM8XUjJ5uJ1Ck6f702udsOaCo
	 H5MWacwHRIitw==
Message-ID: <02a849b7-b8b2-4da2-8835-da29e0138267@kernel.org>
Date: Wed, 18 Nov 2026 16:21:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 2/7] mm/slab: pass free_flags to
 slab_free_hook()
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
 <20261115-kmalloc-nolock-fixes-v3-2-9034dd4ecaab@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-2-9034dd4ecaab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 660B720009
X-Rspam-User: 
X-Stat-Signature: 13njaqa1wf44hosq46c1kf55f1f9631o
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795015309-93948
X-HE-Meta: U2FsdGVkX18jEBBNSnV3z2CuNSWpL5ILgvJAgJB7J9PN/aS40wi6GGojHMYxULVDUcM4osawKR12oRWSsVPin7y+bfleLDBugRcacwOhAJh85mN/nK8B7bEgYES4AvdKA83i3b4ZA4fmMFkafv3+wZNI3VxsYAhewQyEFoBMjscYH8JPFxI6Ykdm3PTf+rA5ItMlrturOatg2sb1gPWe2suyP7EP/yKJUNUIwFNLbE4rQT7TGxc8iDUywuk1iRUp90KFphWGEDbbBSEzmYpKLN+WSnc3+SW/DH9IW7PkTePBDlfyAoRr5ZPI7+jLyK5ZIWJ6xhSPxavpQ2fgmbIS5+XJ/19asl2a++M+cgYwpXFEB5Ll4Ng4RwVgYUniQyG8XhwzYz5bZUUbgook/e7ZNBWcp0CH4/MDdnWIodrdBz4QfDiNghVyTXl6InRudewngZczrCDpyOdlZWgE/msqCuGS/9HVR104g9wuzDNrhpSrhBcyL1gWQ9D5v2zv8jEQ7p9SgpBo1O8MKYqzrwjGON0nxiINi6+iLL0ZFL56yGiMDW5ndFOTEpkqjcb8xN/gOqZLsYa4S9DxFBIoY2+LMOuAy4+IO00QisiRK9Di3BxV7wZAeNVcyEFzRkhNfR/Tm65FSh3EZQlZqfHxEWNtg/nrqY51IZWHDwKJSdtn2rpkvLDDwigOpLLQlyZpXgCbJa98UAWM072RNb5lBQ6L4ZfQ0RQngR6QWj3EvAQHS9a5tR/aWiKHgBvSm7DaiR53XZQBr88liIPxiIDM2xKE/uNGjawQipR7aSoZzknOwCWoyvmy602bf0YxEK1QI6Os8RkEA7psFN61tYpPkZ60lmJjupodZdE5avHFLXoiP/pp0hkDATzGpiEl2rRNQbMxUPiuVrpWt7c0jQMcLAZfG9/7/qsnNielPqeqRHZxHhAG9GoHJyqbaEkS4/1/fCdhObstnf6gG8K4GZ+y9lw
 9lX0HqkO
 DYiIH0EAZ5vtnbM7wGGFhfu7Swokzb4IZ0Ppln8F/yCQxq6tYlzaSHhHTmzyI2NZOcpe7iEp7kjsMgT0TcyEwdVcLdreL4zK1CY4m9uAJw7QSGhaNZuC4pTFg+dCVMZDGKrQQhNxHr41f255xlFFyYibRaoaoN0GI1UVvxBq/HnRq/2Uu/zi15QvD7yNmI2T4rMXfkFMTYCdNlh+0TCXf+XzJgCbBsShH4jVv/vHzlmy5ZxjS926CLnyR9Nz4eEOd3DY0UbKrhM2zas2CmAX/It2BIZb5auruv5R4aC21BUPH4khsuVXWcrzA/FLOp9xEutCYU6zxZCE2irQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 16:09, Harry Yoo (Meta) wrote:
> slab_free_hook() takes two bools, init and after_rcu_delay, and a later
> patch needs to tell it whether spinning is allowed.
> 
> Instead of adding a third bool, make it take free_flags. Add
> SLAB_FREE_INIT and SLAB_FREE_AFTER_RCU_DELAY, and convert the callers.
> 
> No functional change intended.
> 
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Link: https://lore.kernel.org/f31885cd-57c2-428d-9760-a76a0137f989@kernel.org
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

LGTM.
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


