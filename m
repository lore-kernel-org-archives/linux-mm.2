Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C40E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 11:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5056B0088; Thu, 19 Feb 2026 06:18:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192986B0089; Thu, 19 Feb 2026 06:18:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095396B008A; Thu, 19 Feb 2026 06:18:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E97176B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:18:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DA2B1B53BF
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 11:18:58 +0000 (UTC)
X-FDA: 84460959156.29.EB3980F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8805D80007
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 11:18:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771499936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JJcddhb2Zw0ohT7dttP8LGKQyR504gCUKzKJWmgTf94=;
	b=BYtVHbzPKRM5T3fHdh55X/ba+pCVfJ1KiOr/9p/CwQm1K0yhHkHDPTpyRBQFNOGcuqPqcH
	G1dGEDGPNatCX3op0yJ90tiI6supEokR1otQfgIY52sR8vuA28Mr5jQsSQYD8u7n21McRW
	baQVt1POGwc2QvwW11zibVwI89sfji8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771499936; a=rsa-sha256;
	cv=none;
	b=4t1FNa/K6klANSUxNispGEGEwHydbj1MBCR9g3x4EtMm/mpoOIyZ+5JtUh3b4Gw63oK5AO
	gwxgrXOi9ZrK1zRez8jA/8UQAuUDoy5Hnkgbozwniqyq58kQfQ40DAVgQWLWGESaczoQ1W
	GPYipiwOwvsno6jwzMB/q5eJPXg7FS4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fGrTl6z7jzHnGhW;
	Thu, 19 Feb 2026 19:18:19 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id E45F040565;
	Thu, 19 Feb 2026 19:18:49 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Feb
 2026 11:18:48 +0000
Date: Thu, 19 Feb 2026 11:18:47 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, <david@kernel.org>,
	<osalvador@suse.de>, <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<dakr@kernel.org>, <akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>
Subject: Re: [PATCH] mm: name the anonymous MMOP enum as enum mmop
Message-ID: <20260219111847.0000450a@huawei.com>
In-Reply-To: <20260211215447.2194189-1-gourry@gourry.net>
References: <20260211215447.2194189-1-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspam-User: 
X-Stat-Signature: 8ir6otqq8683q1qeyg41f7jdm6ot9bsz
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8805D80007
X-HE-Tag: 1771499935-185579
X-HE-Meta: U2FsdGVkX1/ACjhBzn46X3nMax1o3dOtmpcvVIGt4TtovFRHoCCWP/5nnKek10+tyTl+DvlIcyyepYN5lLkFKrDHTlgtNk3KdJffcpkpHa7yclxqYrDFoCLCZFE4QHpyoo0FydDUE6FCKdBEn1tkAA1uJaF1KV4tvxQ6gEl4MCUPDKb8LLxjLRt7mW6wLF21guhTAMa3Y/I7b9EA6YgNKXL7KRWP4fPUbYCoETgIW0K0i/gqTzA49J3HEg5diWtxTM8ixrsAxBVPHZZTW29rDzFxGP1W7/k6hoCB72gJm3NqMOb7caw1nIqUHn3y9R6QhpCl4fMBrHNGm6p5u9oGc42GEYbyhsYAA/7xO79rNajDxN3Jlr5DdEUXCQHmY3puM2GqludK80P2FVrD4b5FUnQr5PZQeFpCJaFzAuNXahLb6YKkQpZUaUKdeHIZ7VkDAgQDHuCOQMDN6hkGnSNuSuZoTbB4NnR909jymKmh8CIOZjlRARwFTwiqM4hpf5otJw8MprHQKNRLJefb22xhJo9k5N59YUNADN6Njq/e1OqbyLjpmRxGbaXH5wgKj462hnp+DDDXvwtBUTtrPtAj+iJ4pdn03qefWbBzp8V/FxAv1RdgtFnVL7oeBp+WRHrRZX+mtOXynpSXdC+ZsROaqY1fMwPHCZuCoaWeQYLUu6y2CKv9k+dRrVhc3cOcHN3TbkysL3SX3CvUukSL2N8/pqQR5ZCZCx3W+9uA51DXhXTK69OlK3Oct63i7q8Sw3HS02YRSxSbTZBayu/np2H9iyJYirin2wUnLnmKqGtJ8ZgWjley53Jw1fEDFDxSAcDSW5XUnikA1YDOXicrxZgtn3DbThzXVwgApdCdig0Vq1bvN8UompfgNlVjB05LsOlH3rcJgUZ1VbLE47MKZpG3xowYbL0k8p0o1Yzi67ECxIhYbbfqMiJTJbjm2Xu4RMdRMsFkYBTVHSxUVFca1P2
 pXbdb57A
 qrdVu2dx0d1EqYVnsfbJOGdH+7A96oT1tDnSIaYTjNUtik3BNxrBhDLKL8AD+t7e2+e9tLvtx5m2VN+vx7ioxh3Pq9E/sWII4lb714ASKZIwIPyQPKNq2THEvrVCnL8Yz9aQ5M3jqhc5FxPE4eLyyFaYrodLVIWpMZbmqNzSWeNFcGgTc6vKbRyMEpIMAAJl6eJPG0+3TZ0ZyXEvc5r5N4/3WfnXBnz6Q0neDpL01M0i2dSwAWky59GEpiDIpzi57c3aiVLjuOhUcbWzt9RLSEWYel21rLvdGn1butVkWVXsMwyCoSLW8y3vw7W/Mtk0tOMz5uO0RxoBYwmU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026 16:54:47 -0500
Gregory Price <gourry@gourry.net> wrote:

> Give the MMOP enum (MMOP_OFFLINE, MMOP_ONLINE, etc) a proper type
> name so the compiler can help catch invalid values being assigned to
> variables of this type.
> 
> Leave the existing functions returning int alone to allow for
> value-or-error pattern to remain unchanged without churn.
> 
> mmop_default_online_type is left as int because it uses the -1
> sentinal value to signal it hasn't been initialized yet.
> 
> Keep the uint8_t buffer in offline_and_remove_memory() as-is for
> space efficiency, with an explicit cast when we consume the value.
> 
> Move the enum definition before the CONFIG_MEMORY_HOTPLUG guard so
> it is unconditionally available for struct memory_block in memory.h.
> 
> No functional change.
> 
> Link: https://lore.kernel.org/linux-mm/3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org/
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Suggested-by: "David Hildenbrand (arm)" <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Thanks for cleaning this up!

J


