Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52579D64061
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 00:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53B56B0089; Tue, 16 Dec 2025 19:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27A46B008A; Tue, 16 Dec 2025 19:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29DC6B008C; Tue, 16 Dec 2025 19:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 943096B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:10:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4572414086B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:10:16 +0000 (UTC)
X-FDA: 84227030832.09.C45C3C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A34AE40008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:10:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZirnAmXZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765930214; a=rsa-sha256;
	cv=none;
	b=LClmITvM7b8XSS+VHdoLs/EK0yuHUOPEjdWznDAR+eAC1gsO36enpLEePKdRYLaE6HnAg2
	5QiqK6seBTuPzBS0R9TrC+dkbcIHS21x8UszEOJSrnPfIRDbd0aq/t1nSq5t3hDVDQePUI
	eEESFkmC7FwpaQxZDbTUcpcnElHXCrk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZirnAmXZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765930214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ps/+fIU65nqR7scg+9ZWzy1STeyunc9uYsM1QEMPaUI=;
	b=m+yZ05UIKXgmQuem7ujMe6to10Nd6JF8o0A04TEXjVAYT9YLByKQJ+LCvst7A8/7D1pgHa
	KjWK8nm2KU9gL0+HE1KgR+TbqCgVUm5ftQ6wGjS4NYmJQLhpjSb13rYnWsguHW4tUVkjJW
	gyXDJLZ0jS9nLiXlA/b149OVFnyNf50=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A7AC60137;
	Wed, 17 Dec 2025 00:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25A3C4CEF1;
	Wed, 17 Dec 2025 00:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765930213;
	bh=IYStEoceGdUEi75BLoyEocdK6CZd2MmP8jcIyjKww1A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZirnAmXZntKqQ0k4HUVwGi1YqYVeSoRhusTvAg73iV3t9VVhPLhTsXP1tLDbaSb3X
	 apvbKAHL3nFZTB2DUvWUBOX+UygqSJYs36Bd1f/rfWT+X9JMBmkS+Z4Wsm60tfypPv
	 GS7Tpivbn3/VRYA1dgSeETWVHA1rgJBpOT1XBDXFvwhAlgRHtrUpCfUpnd2vhbxQ9J
	 GuBCrHKguP92bD8aEvceF0rTOXp/QF/r7HHua7AwcZZXwfttaEectmb6IpwvlGO7ty
	 at+2FhZS6ng5dxpbwMuR7D3MansmP2/DRx7Hi/COKlO2DR5FQE+MxflxWjz660r+Gi
	 JlpZXjBBbQaqw==
Message-ID: <56acbfc1-51d7-4245-91ea-45bd9e4b2e29@kernel.org>
Date: Wed, 17 Dec 2025 01:09:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/14] mm, kfence: Describe @slab parameter in
 __kfence_obj_info()
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
 <20251215113903.46555-6-bagasdotme@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215113903.46555-6-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A34AE40008
X-Stat-Signature: 9ant18s3ifh6g5pwrtf3krpzi7tzqmik
X-Rspam-User: 
X-HE-Tag: 1765930214-90801
X-HE-Meta: U2FsdGVkX1+UK2i8tJ0RxUOM62CpF/6At+nxpq8xhoiXJ7pnfiFcHICRt4jmut3xA5LeBeVO9rS+uvuyIzRhZuls8aUaQ3nb2PyqIe03r2kkTdX2V6FYWiXVZsjmW/Ec81aGAA8IQF1V+zRdj8+eKO26Oc+2G6WGzHA6+vFPIhLxEOtYZsEIp5Rrp82tJNjdyKdKWXmaOfkNHO3VIqM7PCh9AUcQYQgtqoPKQT/sMtY6cbp9kDLitTPXYLeOCVLRnUgI6DJ44sZxE/i1TYBf4AtTaR+P/vcmirOGiab2Cv1FWHumPKMKUqst+G5DhH4ouJoZv7cMYVaaHrFYL9WHzbmj3I8aqh8cKnIoD8H7HQ4awOg2aR6KEUSEajQcSHdvRWo93ECbet4Hn0EXvh8NB7aTw7CyrEgO/t4MRcI7JdwNoKYOTSV4D4M8rVRGHr8VtAQthhItmVB/j0NRy++lQ69hoxTVt7QyNw+YJ9vJ182fi+zWbuqeq61VcAzXJBpZK3F1pWeKTXM4aJ7fU6kVKy9/Q0o1bAye9XfMu9l+im3HsskET+YGG/gHjoqOxRdWd589e1SdHEh8E+sUfecJOQz9+8mtzUlfAV+4rDHav08XirH4bq4jWCCXyFBueIXarEV8WfwlFMhJv07u5IEzQuMPK01s6QwrAMV/rktpx8/4AJKMemgHRbA5XZc3dm9njwsSPSqU+6KWdJRrCX1ZXlT/RigjIHkihRDhATE1tI5AvxpkeegOH/rJ19JyPLJmJbGR1cPUshG5vn65904bXAi848zz4jan85DL2PPuGV00SkBaQ3kQf/nbz98BTHkpUAHkbF0CZ8QsbUnmoxfyR2mqYm1M0P7bwjVbfh6pyASADa5o7RTwB6QZW8ToTtMOmLVwSYCU4JlqKqm/Bx40c1A6thwSTdZb1DBrc3pvSGgc/ZaHZ2fUsyM14NeSIDGDTRYV+fFubBHnLuqkZhs
 nDM3Eb/5
 ENDqzG4x8piqDF0TKgNTvdWi+IWOgT1YHQdTABUlAGYw2jZj9K45EmU5UioG18Q11eOZ+q1nsf3AwPeHKu8V1XvqAdH6n6iRzYxRkTJz7moOBzXSBxmuMUjT2AYHWodcT2WKUMv1hb5ktNAafwch3yIJBvspSY6W3oM5/X5g0zccoM01vfwo6R0ow4z0T7Ox9I+bXL81LC3JamAAaLZyQsJtAuYAl/2BwIW3/XtmKZe0G+huGrFS/S4YMH45YGigqGWNRQ8cce+80BeYgVIX2dzMj5695ecLyk3zVQ6egjYYfE1ZHDxm0QrhVaekNwW0i5xVvtuRv1eHHX85iEUn2eZMYDRnstjJkJZ47XncBsPurST2o4SOedkHv6yVLfPtSoloG
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
> WARNING: ./include/linux/kfence.h:220 function parameter 'slab' not described in '__kfence_obj_info'
> 
> Fix it by describing @slab parameter.
> 
> Fixes: 2dfe63e61cc31e ("mm, kfence: support kmem_dump_obj() for KFENCE objects")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>   include/linux/kfence.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/kfence.h b/include/linux/kfence.h
> index 0ad1ddbb8b996a..e5822f6e7f2794 100644
> --- a/include/linux/kfence.h
> +++ b/include/linux/kfence.h
> @@ -211,6 +211,7 @@ struct kmem_obj_info;
>    * __kfence_obj_info() - fill kmem_obj_info struct
>    * @kpp: kmem_obj_info to be filled
>    * @object: the object
> + * @slab: the slab
>    *
>    * Return:
>    * * false - not a KFENCE object

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

