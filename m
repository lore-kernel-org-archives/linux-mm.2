Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD8DD637DF
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 00:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3CF6B0088; Tue, 16 Dec 2025 19:09:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591446B0089; Tue, 16 Dec 2025 19:09:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448736B008A; Tue, 16 Dec 2025 19:09:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35A856B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:09:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2EE71607DE
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:09:42 +0000 (UTC)
X-FDA: 84227029404.28.D68D7CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 57298100012
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:09:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aNI6UMU2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765930181; a=rsa-sha256;
	cv=none;
	b=DlR/9CDX7cxCD5sBXbDzuqLccgvfgicGWJEo/kRbx6HrT1Ri12LlXB9j8D/Mi/LqfnvVk2
	BMYeK/VGi+t8oZ51l0kSpX0qPBAhGmMYyrQiwKmn87N48znZFsJ6A6okvhKyGNPNzrK4py
	FxegCTASVcvfwhPaQ552Eo1xdgltkd8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aNI6UMU2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765930181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2D6wcNN0uaso0Xagu6VBp+odIMbaMvcazTe0F3KqMQg=;
	b=MxAu1N49tGaWyaboUFqtY5rcTgvSZbVLrCXKScxhSsKTKc5nrpkD5sL+Q0W9a8S85qU1B7
	jbiiD5b96QS4QVgUKcp+VgYKSntEf8ql4IoZoCIdrYRU0sPqwdhpGmT+L/FJYhwqPuOIHs
	tNLI3nNuB65b61gwrU+NJRAPxsjBC38=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA02C60151;
	Wed, 17 Dec 2025 00:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCD5C4CEF1;
	Wed, 17 Dec 2025 00:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765930180;
	bh=aZR9wSyi+zJsIHvJriUMfLQABKctzyX5fXgs8GO8n4U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aNI6UMU2+C9auZatxSgLKTA4RJ8Tc8yGSyXopvdXSVgldtvnHa6Ken0sARx4y/+7E
	 vTZ50xFdj1tMQ//XOkLKgN4vvA0M8q5a90sGtX+/o49rR0WOpEAoagq+nWaDWWFzC2
	 A+ckdLIbUqlzEVk/gc+gkcqWB01O7qoty08Du5crzhaVhPQGYiiWrUEyDGfCxakcBV
	 7/Vhq9JR056MU/kxoCZ6IQJrLttskLj7lv7AonqdrTHCXfFEdheN1OlszL9XqoU/8Y
	 GI4TxOTez3ZYyi/BtyoTEdpc9tG9UwXITx9UVU576wwFjXer281n4kx9KhSKtCsvy+
	 odgHmbJMW4r/A==
Message-ID: <e76e25ef-f112-4689-9753-34709613b9c2@kernel.org>
Date: Wed, 17 Dec 2025 01:09:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/14] mm: Describe @flags parameter in
 memalloc_flags_save()
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux AMDGPU <amd-gfx@lists.freedesktop.org>,
 Linux DRI Development <dri-devel@lists.freedesktop.org>,
 Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
 Linux Media <linux-media@vger.kernel.org>, linaro-mm-sig@lists.linaro.org,
 kasan-dev@googlegroups.com,
 Linux Virtualization <virtualization@lists.linux.dev>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux Network Bridge <bridge@lists.linux.dev>,
 Linux Networking <netdev@vger.kernel.org>
Cc: Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>,
 Rodrigo Siqueira <siqueira@igalia.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Matthew Brost <matthew.brost@intel.com>, Danilo Krummrich <dakr@kernel.org>,
 Philipp Stanner <phasta@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Taimur Hassan <Syed.Hassan@amd.com>,
 Wayne Lin <Wayne.Lin@amd.com>, Alex Hung <alex.hung@amd.com>,
 Aurabindo Pillai <aurabindo.pillai@amd.com>,
 Dillon Varone <Dillon.Varone@amd.com>, George Shen <george.shen@amd.com>,
 Aric Cyr <aric.cyr@amd.com>, Cruise Hung <Cruise.Hung@amd.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 Sunil Khatri <sunil.khatri@amd.com>,
 Dominik Kaszewski <dominik.kaszewski@amd.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Max Kellermann <max.kellermann@ionos.com>,
 "Nysal Jan K.A." <nysal@linux.ibm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Alexey Skidanov <alexey.skidanov@intel.com>, Vlastimil Babka
 <vbabka@suse.cz>, Kent Overstreet <kent.overstreet@linux.dev>,
 Vitaly Wool <vitaly.wool@konsulko.se>, Harry Yoo <harry.yoo@oracle.com>,
 Mateusz Guzik <mjguzik@gmail.com>, NeilBrown <neil@brown.name>,
 Amir Goldstein <amir73il@gmail.com>, Jeff Layton <jlayton@kernel.org>,
 Ivan Lipski <ivan.lipski@amd.com>, Tao Zhou <tao.zhou1@amd.com>,
 YiPeng Chai <YiPeng.Chai@amd.com>, Hawking Zhang <Hawking.Zhang@amd.com>,
 Lyude Paul <lyude@redhat.com>, Daniel Almeida
 <daniel.almeida@collabora.com>, Luben Tuikov <luben.tuikov@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Roopa Prabhu <roopa@cumulusnetworks.com>, Mao Zhu <zhumao001@208suo.com>,
 Shaomin Deng <dengshaomin@cdjrlc.com>, Charles Han <hanchunchao@inspur.com>,
 Jilin Yuan <yuanjilin@cdjrlc.com>,
 Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
 George Anthony Vernon <contact@gvernon.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
 <20251215113903.46555-3-bagasdotme@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215113903.46555-3-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 57298100012
X-Stat-Signature: xbb79f9stjib7ykacs9imiiugcnnfpjb
X-Rspam-User: 
X-HE-Tag: 1765930181-984896
X-HE-Meta: U2FsdGVkX1+qr3Ezpgosnh7/LoCBlKPKjw4At5c45K0uYVoJTTQmczvIB/irawBfyw5k/tfB47yG2gUuh4h16e2SQcCTXRkGp42+sdWojAK9QlmBgS9mt3JVU6sY2hytPM/3BT8y0QpUMVwc1xfbXmgYd+YGHY4H1wFiA91VvIiAnVVQJx23cxDqxakIdomdESo9gNV1WHr2FUYBuKyT5TuBePodOdjYblpoM5joBSVtyyo1SZLwIqqczdkcgPpT5bCmXx3afl8hhPMG+kOtRaYagod3+AybZ+XvG+Z4UQlVX73f/jCjsV94h8wX/+BBpm5Cg+vhQyqrOYR/VOjDXRkPGelSgGKbzAeXU8YDnHYzWlAg5Q6aZoAIXrVyqy7ttklk5ARJJW2ezOiChqC9JcpbDfMEznx8qr5taTVwjQY1eY9t0ysxgyD1xOLGzt3+5vx/vP1iW80/sOClIlKuhOQRLqF8IrA0xC5x4n0cJupP6WZreUNUEzfeqogaJRNdzLc2xJ5Aa3Kju2dnAZKg0OAmYieDMmbXsxHRl+a2Qc5TcLGZAhh2pcRD00n4SsDxhudgWAaA2eWQlJdERq4yEjZcv4hBOJln8jFnKQO2kWN+6JO4C4VmGVTeEe0/cX6SEchGJrbEL+F5W+hNFf9kGsTlve4QO1waMppDqMVKASLCtqM4jQtLdyF+gx8sCC8h4cblT2g/6QrQRuksEtYnX7XGzUvrOUl8mIB6MM5CygebbDjV6lRub3I6Od+0g6GAjWn5DYWQVZOcB5XKcqssGuM3h0oJhUe41Au6lX6kea6Y2/Gboqw3N8mltkYIqCF3DAPjvnDQKUQc4G/PAEa1Zv675zcXpMrl+9BLf6vvXOZD9OuPV6672/T2zfIeXlB9LFkwUQHqJUQtk+7nmeismQL8RLA3Tt8c+08x32NhnCKADf6ov9kjX4bocW6KgSEpJmhBtY0htkXH2JokkuE
 sWE00OJ3
 1P5+Ha1E78uJuPQ5aBcttkzIkQIRHZ9WSRFvLe2EjA0Dsaapm8W3FUR41+vATyHok5W6V0YShMTeVAxX4DPtwIVO55hTsf1+sPiDRPlOnYiBuWvgNMIkJlUNswH05PrXEwtt41324/t4rKBbh+xNLl+rCdzTCKBa66u/6q1w5gtvK5l2fNyry43/83RXedxecbKvZd/GHNqUm2WiXo7OktxXp5OHUA9GW2CCb67WUxdZa7GGWxCikhspryFFB93/W4giFakncoxUJVqGS0rJZfw1wzAcH+K3dwpHOG3P/0xIM63bJVH8O79PLlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 12:38, Bagas Sanjaya wrote:
> Sphinx reports kernel-doc warning:
> 
> WARNING: ./include/linux/sched/mm.h:332 function parameter 'flags' not described in 'memalloc_flags_save'
> 
> Describe @flags to fix it.
> 
> Fixes: 3f6d5e6a468d02 ("mm: introduce memalloc_flags_{save,restore}")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>   include/linux/sched/mm.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 0e1d73955fa511..95d0040df58413 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -325,6 +325,7 @@ static inline void might_alloc(gfp_t gfp_mask)
>   
>   /**
>    * memalloc_flags_save - Add a PF_* flag to current->flags, save old value
> + * @flags: Flags to add.
>    *
>    * This allows PF_* flags to be conveniently added, irrespective of current
>    * value, and then the old version restored with memalloc_flags_restore().

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

