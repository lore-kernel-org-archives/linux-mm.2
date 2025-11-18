Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2920CED63B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 13:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1556B002B; Tue, 18 Nov 2025 08:21:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C93B6B002C; Tue, 18 Nov 2025 08:21:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9F56B0030; Tue, 18 Nov 2025 08:21:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEDA16B002B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:21:54 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60B1A5957B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:21:54 +0000 (UTC)
X-FDA: 84123790548.22.E785172
Received: from mout.web.de (mout.web.de [212.227.15.4])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5BC951C0015
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:21:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=QPXw7pF2;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf18.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.4 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763472112; a=rsa-sha256;
	cv=none;
	b=Axu6gl+P/4g6ao4t86SZbrGrluDrpCq4j+6CWHLWIXnRIHOFlY4BkfhdrWlbh6dNhvDDHv
	J62+NXtYpo8QD3UNJJ8lNbWWjUuMjTnNWyy8/NLa6WtgXONxnyuQnIBSaVuy4MANoa+n1D
	MTIln2FK40qw6XN7O3jp9eAcd2Svbkg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=QPXw7pF2;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf18.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.4 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763472112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WquLOcMgJfVEXK2CgQFm5guESJ9p1cI/U+XjhipzqOQ=;
	b=11TvPUXazWl6Q/oa0OZ49ZkIRbaEM6igFTK95PN/HVervgruchj0GRzcxt+dEPMwaOSIPK
	LcAlz9qUPY1fhsuszLv1NxDeJPcDybbhr0CSuqYMBod0+IAtnC+IxtcXhHUOfY9yV3RD/U
	ApjuEjScppIl5LQoevGl/v4Mg49oILA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1763472062; x=1764076862; i=markus.elfring@web.de;
	bh=WquLOcMgJfVEXK2CgQFm5guESJ9p1cI/U+XjhipzqOQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=QPXw7pF2/oxVI2J7+K/6OljV4GQi79MMTL49vzdOJe+h4c4llsablqR1D+M8XdgY
	 0GOH49xBXxro9Ux4+HG1Vzx2URzuid5thSsxgoYqgC9fFk7KWF19xjGW57mU+WRS0
	 bY8R6m7cmEB/dhNqZdeLxdf4E2ZP9I3JgMHb61PtxHvvyMNWPayxmCqWA9AnlHisM
	 bUwATJT5fdr0dkKOl22A4rBCMhvUhOuuAMWuhiyvKi0zHHjry1sr5YlO6GppI+5A0
	 WT2uDa8JNrGN3oR80wKfs4Qb1kP9/v55ladkTWiG5kAQvv6KcO6kwFQCxDOydRSI1
	 DGG5GeAL0KAriJNB4g==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.234]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M5Qm1-1vKWpE3RmH-00FfAo; Tue, 18
 Nov 2025 14:21:01 +0100
Message-ID: <c5f92735-0e2b-48e7-9181-04bc058c0bde@web.de>
Date: Tue, 18 Nov 2025 14:20:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Sahil Chandna <chandna.sahil@gmail.com>, linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>
References: <555cdbea3a51898e4c84fdc0f444dae0c2e20f24.1763227530.git.chandna.sahil@gmail.com>
Subject: Re: [PATCH 3/3] mm/zswap: use %pe to print PTR_ERR() values
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <555cdbea3a51898e4c84fdc0f444dae0c2e20f24.1763227530.git.chandna.sahil@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5WzJd7YQF8fkYajMJ+3mWCrfQAvQvmJTPXObZQbUU7UE45oTiDv
 KhgoJbXYtcCQd+7M3EXZg1KvXNYgdnVT96tYOTSJGGCdAAAB+9Golu2CZ84bkxkC7OfAkTS
 A2IM/6/EuO3NjW1NChDXd0fkihmjQOzUlOid5I4Xn3UEh7zz8NAkH/sewQjNNIKlK1AUYEK
 baiajXGfrIvWmm0I0RlHA==
UI-OutboundReport: notjunk:1;M01:P0:4XRIWBtDHMk=;nI8UcC/EaxNt/HZZfCdJMhBPS6o
 t6mhYgGD0GYI9IBWxOj3ouL+q2Im4CxP4BZvsYTOPCVc2wo/bN0dKCi+2noYlH/9zygTcn5o9
 rVuslu37+rlSGapAZYEPRLZ0eyGOBgFDz4yfhOPslkiQrNLmcmVzHgEnXxc9BvnyISz1TC10L
 spVnMalv7zrDmFMLUMGAQky3tKcNv199vyftkNq1lZJRlO0CUkhhwwi5dTIzKgH98PxMXN7bs
 tdLH39SV3hta7jyF0tgbbltWta8wl24ZNGqiJ/dA0lgO5HNvWfTrnCkvSQ+e/EfEab0kJNJHH
 WykXtoh8IJ++kYHhzSRMdZWITNtfaG3WCssAaH6iQuDXA0oUKYx7e6PEFmQ+by7cMcx0FeANX
 /zZA9Rc+GIB/H17J0FQS22KVdd2CYbBX5dGcOPzeAgZOtLtjvAc5n9SPqoIQfG20axXjFmAr4
 hKnJYXLaP3u+kQvc9xcYR4pTrkfPeuWDbSArssyMxGFhrNhof/jXMHeISliHxD0yC3CtcEexW
 H3dLgkk8Rqap1mdL5lzHbm8DReSaJdCkiJ82BBuLYEi4HuEgR8gIq+C1UrU+43qPFwFR/jMml
 6evMweg3QatZoeORP6rd8w35LqzCc15FJJdqAbd1laGAiRWa4zUF/tkM8i3U6IWk9kpYgqvYD
 2PonthAvOUtBRF2Vinsihr8pnfxo+52GNZYmC25+7mBNiEHAqYlKu0JN4s/x/TDY3pXoJ5J1A
 m52I0EPS+FsbJ+NalBlWZopiaNSvOUpCuGriHuWTQTD3i6psGWt5XPtWtxwiq+zBJPlKX2u7E
 i917lFUQ0QwKRXIxDauA9rvCEL+/mfY/uYVo0exdxZE+CkL/Bu7bj/da4D/4FL1KKkGmUJ79x
 QtrQE3owuQQu68bbxAJUy7gjbvAdDdfjo02o3H0Dtaf0v9s1WyRbdOE9+qXV1AKA3e7xZyKRi
 yexqfojOSxcgKxLhqEYDoP0NTRw6Sh4M9vi8ywU1On4/JWFj34AvQO5lGC1zhMBbBrR399LGG
 GwXPYj3fvMR5Yoedw9YSepgFJkDc3rzWyGS/f3HgQXl43Iz1NP8Zcf/2ynRNJdAaLUzZ1E6CR
 PAFPLn8e1+f83tKlchToyp6cxEQgczFbakIGtmKTjkLz4xjG3rdVCWdP02TyP0GJ7/q+viVs/
 oGUONyQzBMe1waDCPnQTe3y65jck/uPtX06pBvxQjLVsdYuYJ2YUo+wwaOWh2KYZB3T14qqh9
 f/OpJDrZOlJEsKh1O9eWW9JaO+y5kaZAmwme9oGPBcpwjIum5CLIH+ZPwmaZs0H7EeapLSqyI
 5WQRuDfMG2eo8w+whRbXjdZSRoCvDDDupAtiQnEZHNM95QiAmZaf8BJwDQlnaaoM7tlnFHPLu
 LxiNVeftwNBXSo+10OMpQot38RWODlFZI2/60rkgtia8/yTx5zVlr9ZZRXGbvZPLeHsyZmT04
 83+V1qTiQ6FHBrQrOUbhCmQA0sBlg8oWVuz8OvkCs9RllpTtjKsBEI1naSo74LfnbSSAsO5lf
 5NlktnjhfWlvP8zJAeOngwnL5L3LA4RIBjKBWzOjJjmTx1VxB/r5XVTP8aKgG2zp7IznkcSzJ
 N1BW/lvkvl8XmqtuU73aft/LD5wcASZ/g3IVniay8tZLSMw3k5P9foAjy1SVQQaNV9jCecQP3
 wwxm8Ya8Njmfocj61SBVuRYvx1cb1HkdeFnbNzeoEhpE3E6l0ib87+/gAew7NjlEbQnpnmUxy
 991i2JS98EWjSi0KchaEuDNCwk+BOYQhK+1ergcZUnZ/yUEXqPTOPYsZqinVX2ywhW2SD3SXk
 v24wYmJfYbuSOnFCubJQs/Ugmhx7iWAXdOp2tKOcG7M3gVI79cSPtBJPESNB5SNgNR5w4GSsT
 Bv3IX31ZLnOmA75S8sDhpEMQ2yUyO45ebzIND+/yppYnnCxnPqr8uc4/eKS1h3VVpyqOMr5IO
 cPjIV5+9m/UOSmekdzlTEdHCG/jExGekoiS25UtQr7eGwiyioBZcpffyW54ylZTSZzX1lIoBi
 bi3bNBU/wrww2c34c9sOoz2HQ8TDke1dtimiB1gMvHTpQ/H5nYns3Rgt1yXGvpVjj+kS4uTim
 WpDKSTqxgy6sIo2gAtbbH+LqKJeOVYFZc1mZAe28iDgTybyw3Khn3ZLlIdkeOjILmHw6FU9zq
 qgZRF0eFRK/f/yz+nwg5nb9m3sApJZ2vBinDrgJWIIXhPw2g4/IGZ4tq+tR3S/bFhLuryq97H
 +xzCNMoTMSI6RXLRxWjyRVj5cvOBKFngPOoRLciS8Zn7CqMZbcNJ3iwAp4PuBEdvG4hOBUe8Q
 KfPVWuva1AfNt5z5nJmRug3PSOkYrvymWluN4/NY7H9RmFunVXSoX7PT7vOeFzVJVas9sPo2L
 kD9I09SlkpUzYTEGO8Arzvk4DwF3yFustukABZYy2zD6kIPnlR45XLAlC/xmW4bxkh/wyM4Mg
 Ed2tCzxyD5h/QXEFP+u56TgwYCBV1PjdwW59mE7gyfcb9IY8HPht/2BehU01ZD570VSSjhZML
 VkmEQ1s2wo8lkrUQ1rJeo+ul8OTatr0oyMm5Una45VdKThFLJWUd/dmJZsZf3S6cSnOw63zKn
 rBebUMJamBZqyCDoIBm4KSVW4vLnEWvBqcbMS6jgRyGvCzgpxr/+++/0PIFFPGgA+AV8gY4kR
 5Aj41iTXOcyOpA54W9Gh0myrj3pObK+uEBlUMC5y3cA+tZc6Tfjq0TcTZqWmrrM8kuCqmI5Qe
 ykhUjrtDl11PgKJ947YErUgRNiJR9Bi+tVWDLQ9afsLOOEpFIpUDSxl0Wk2H+Z8hn3xPyeOHU
 EfAX3plAmxirYZKydlGHuQe4aepHy2VEoyrPaW/0qMeDMkmTiU3XyB3i45KJKCLind4gu0QRH
 TquNf0Gitshx2aITNGFL0g0zeguemGhbIqBUGLR7TyoBoYsfGIxunBGLCCUCTMNQXXeUExGTb
 plUzHZzmMJKrwj6NJIRBDzQKs745yVyKNOI8uM65hRpXdJqPbEJqlIfFrYpAGwkXUfdhyQKbc
 tcoxVMaKtVwdzG5QU8M0hsbdkrLzi+PEjCvPluUvFjmUVhZ3goLqurLwaDv47bZoGstR/9sR9
 mmJY3tLAdt1d7gpFqkkKNMwJgsHRXsaKJG+13CB40EPuZp/EQCmb+yoQc2M+Ai4mpBJXr8NpQ
 4aXshyuY8B3E1ixezam3aXmNnkHh5dx77AVY5iIM8Obqspa1OgVBwvtjDUEzYC2CKTqN0SXlq
 +j1KyHtJvhGfqvRRJeYnFvfSoIDiCKG/kRZVrm8PtzZbKEWuIU28hKF+/AhfgVaE/nhCF0UM5
 irTVtikAtQqDsUHlvxBud4TaJZo5Xzzu3uScSki8/KYQ5D5M6bEOmBUsHRwuYydcK7WFv2QPJ
 fW/iYGmBV8HIRUm0EfIKGOzDB8v0Dzm6kmF033Od8IyVY1yBPHZV8OqsQnYyFdh8htTNTUljB
 Kw4l39q8m72c6craL3TCWBnBtsqnAVMoo5C+u3YV5N73tymJ7TJXOof5jIfYnOrlW57UYsOAG
 ufoK98PY4T8LiL510lMy86g9npzoYA9Agndyegdp9V2JPScgIPJ0O1OJXeFjLK444tOJsbYbJ
 gBH3fkcaFeDGnHtHidyLr9Ye5Npu6fyqMV+7tpEsnH4nBt51BQzR3vGQGFBDIeP2kxgnRqKS+
 xKGV50GP+NGJI/iLFAlE6DGdACECmNIGCaqk6RBPbSnKkIb7H6avzUU+Rp1F8oU3yzV8Z0kwH
 SZVxyvID3PZv8SMKbH88HIbjIUcio3FLLYDQgKAu6OZYNu6j/U06u0oR3QnZweKBYW14Knips
 E236g3dmSkoAVcleD9psB3XYkMqUJpy/NX4nwV/B7P+LzaOvuRlVt0C88LoAumyFL5XmJJmay
 iIcUwJF5P7X2jUf2bFczLUmD03i1z75+J733HeTIGwQIbMH5NsBA5INTgIwE2oeDvH2w+l5hH
 +3Vk/UDj+1ldoIDLpaufH1AWpFFZL+yND9HbsAAcP60RaF1xYnVXtOEQk4VBcPluQ+yRLokdO
 b+WJZdhRX8KrRj+wFtBsAPDgsgN9lYrzk+iwZjOSmMfgfT8EwsTNl/uJpTxLD1LFQbuOwKH4t
 lmyxACrNG8raoifDYxlYyas/ur5vBH0YqKU2qZDYqUVQsqVsYiqI2Xgq9G3xKONafspEqmxiF
 B8+oisPlPSOhiL7Jc0PVVMHrGrCC1jKvA5LakHO7CVNexrPi5n7kcBjlu4R6wMVUaf1pX/m2s
 jEulYdU2BiY27GpWI9Xzr7ZIWUhWgBwlskRXC11cggiwYQQU5sexfZAUj9kfSiFj2D7Y1hRPk
 qonVdJlaQqXtVncM83J2rJx9/yDqzjWlUqRJC7xxfD3x35Js1BSyLfYjUkSBfTZ4+5XmVDoK8
 lsmx/undwOc2ZhxiUWxu7EVBDqNkh43e1PHxepuWXfDXyhZL8XHtKpsCOWwEagBEcpgQP7azW
 rFsYVStqz3z/FZPTm5F7aGFYIvOHNxT1Wje//0DD8Rw/ir2gatzPq3kg5Ccm+mdfcjxxdKniG
 NhTc9SEx+cz71WTzP/1hlCmaDbxKOe6XP08cVLOC7BiI2VPsjcc7s2StSbTgBI5hID2OWa2oL
 EtosqA5OR9kqDOVdb/j5EMbsfoyYqtgQ69hQZtgy6U2KaWvGTbKPJCCF7lwWUgqwxii60FFNH
 mFoUrBRFeaNZLgiBVd/awhQscUIXavbU1igh3wuE5+pTaluk4YnLNF8MoycJ3hfV5h0Q+er+r
 BVbcL1txoveXgDBB2X49ds6KBx0Hclei5PISpj/7VSkmTaVJpSkOilJWDoOst3bo5l4Kr0Py1
 BLcqMvril94DVPpRduXXiXDpzPG/v1CU0pBYWOaEyvoZ2SVwReIjZTTbyQ8wgviSZ5vgk9GNA
 qkTp1sIanhLLjbOiOyTCWVN0frgSRXlOuST0URIgTgZf8xIIfhWb3IzWsgcpVCQiwuwnWZqQm
 FYW6rf+tsCrvm1aaWj+VDeUL5EfXkF4T6wJGwZbGmFvFNvHPWjdLP4siBzLAx9ckLyg0U+XC3
 bRWfF7/V2ypyILChxd3uY5UxoprVGl8Z93kwAf5gDYJ2ad9iZBnt9RBVKrqV9UMs1nWRg9Ewa
 GN4eDa/55bzjubIbp8LqAHZiH7KNqmweFOd/qb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5BC951C0015
X-Stat-Signature: zuf1hnyehubxoyamspki4ajrpp5f4gw9
X-HE-Tag: 1763472112-739496
X-HE-Meta: U2FsdGVkX19a5+heFqzwcddf/3NoUEGkYAQ/HUydi9fOHdwj++1kOZ3/r/HYKfYlH64Gr32wuG4RPmKPsNCORMEA2cJNRuUKddR/Ka710sbgUqUxQUj5tb3OeUQ0IOTRsB/TvXwN6l7W3hRnAPNtot3t0uSfvy/4oyHyqgrfOUR1HUxIz6Qm3LhKMs1B8RNCGW8xRZXP2xVWFFs+PiedbzLNyqUZLwdgUNP1jULLT//7Jg8ujyvq83pnW933sImySqRoH/K7p5dTYitfbu44iM45iXsT1BznQ8HKLHJOiDNt/bQQp2woBU/sL/fIP7Yld0+I6n/noEOciy8F8InddflDtp5pEgHGG4UNNPO8mVJ0Rn/XmvfpMKnroEHD7oFaXyo/6pSnSiQLGwmGfCnZky33VsLKV8RKrCPqtbr75csmZXWctWKYcbJGPCap/uLieA2doRpEj/FIsjKlHlIk58Y2PydXukgi4Uq6Y2KFgGsfMR/MeNpS29Uvue8HAYhqKSVROvxSkpBDxbbKRu74J54u0R+URxwK7kVkpin1liJzrGodljo1d4D90Vgnrs8TLxxOcQVmOpfxkpVtb0DM7w5bZcBJKhGYHdgntmr8Ub1/xQxMHe3XZgw/mL1lySbhGyzKxYogETxm6oRfJntbRr/9yTrLhtF0Er+J+1Qb3ZxP7b+676ieqk1RYaVe16duadGrJoIM2UeBM6rC4EotngJhWvb1H1WmhoXc2bPN2EJMNuZbLwyR7bmJl2xItO1C5axMgvYVnv4+lYEvowVwNTDHDhihoHZMpVT981Dt4H72YiYU58y/VrONoB8yUHsddX98c2GdC1Qi4dnpP7MMp6z3fByYWCl3z076X1NldUQ+t1go9uwBCYsUd1i2lEiTyKyhn3uhMZQHatktFhmgVyXdkChYBlHaCB2duVx4VSQpksWq/GrCNpNtmqQRtZEmS6SY1PVdGG91XcWjraW
 hYqN7Tlr
 zxInX9cXvQOR81h85+rfPB4D44tDzO/uosLtM/qaMnFtgbLg6coa8sBTLu0Z7XiULo1cgdjhPzuLzA4X77s4YyGOyrzSBP3xCgjnp3BsHOxr7qxSQu/RAsfJLtGZ79EAnfsi6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> +++ b/mm/zswap.c
> @@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, =
struct hlist_node *node)
> =20
>  	acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cp=
u));
>  	if (IS_ERR(acomp)) {
=E2=80=A6
> +		pr_err("could not alloc crypto acomp %s : %pe\n",
> +				pool->tfm_name, acomp);
>  		ret =3D PTR_ERR(acomp);
=E2=80=A6

Would you like to reduce the indentation for the passed parameters?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.18-rc6#n110

Regards,
Markus

