Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5723FF494B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B026B0092; Mon, 30 Mar 2026 03:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB736B0095; Mon, 30 Mar 2026 03:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA136B0096; Mon, 30 Mar 2026 03:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19AE86B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:20:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7E378C3EA
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:20:22 +0000 (UTC)
X-FDA: 84601881084.30.DBCFC16
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf21.hostedemail.com (Postfix) with ESMTP id 32FE11C0004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:20:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SC4qUK59;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SC4qUK59;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774855220; a=rsa-sha256;
	cv=none;
	b=H990gWL6vm1PLKP9f7p/8Ej8PQWEHnen3sdA5VKcbx3WfPv9AMcaKCuntMrzYE/+tfv3U6
	fmkNHXH0LqznDUsjAjh7/uonfdvnie1sqdz8T5Cn9uHGiZ7myUFqRz73hHD1+w5J0AJtII
	K7kMsM66pj9P/5PnYHPAb0TW4wlCTk0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774855220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pepwZ3XKeQcMZ6zDSFXuBMobmmIw3darhFzDaJYBZvo=;
	b=jsAez8iIC+2UDxg3MvFqguY24id44dF62S373vYTq9Mr6r5FiMB0tQ5pysGe3FRlbRHrah
	dxF/Z8gvrO7NXce+LfFf1X8/JyY4rcjQQZsDZU/8j2O7Wc8ZC2hLPeiqU78WeMelsG5SuQ
	FaH+JqJX46Gzpx8TaiBHtyjyeH6PI4o=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pepwZ3XKeQcMZ6zDSFXuBMobmmIw3darhFzDaJYBZvo=;
	b=SC4qUK59hXpDZXbq+rPtEwSr1lC+YENsS5x5oofEvIuSsoICbJPp57M5OelZoptVim7CiUqx/
	r8nOFQmo2RwxP5Kmc4/H/PIQiN989RJVpw1UQeNNbHRb8snsbRJE0KvJWuq4NHwV8wN5XiIqjoA
	SQbdFIIdffGVUQ4MTItX8dA=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fkjCy0P0pz1prKb;
	Mon, 30 Mar 2026 15:14:06 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 6921D4056D;
	Mon, 30 Mar 2026 15:20:17 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:20:17 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:20:15 +0800
Subject: Re: [PATCH RFC v2 6/7] KVM: selftests: Add memory failure tests in
 guest_memfd_test
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-6-92c596402a7a@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <149c954e-dfe1-6bdd-295c-792642a9d915@huawei.com>
Date: Mon, 30 Mar 2026 15:20:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-6-92c596402a7a@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 32FE11C0004
X-Stat-Signature: diiqcwhmk8yo5haqtpus6dtdrs6g986f
X-Rspam-User: 
X-HE-Tag: 1774855219-6084
X-HE-Meta: U2FsdGVkX19Eg86a3p+drq1ccG1eVdHudxNB90PJNnF+PT0/HOOxNMFJmc1XZnu8O5P0ifNVmKqwUlTh9IvhicVGd9gkbs/bxPfXXQbpa3i0fIMC9kXob2GEFLEBhIGmQPOzafImS9FXw6nImzR8u6l83iUCNF9X+6TUgx3I4Q6O3nhsi8L9uz7BFqdJTSbwLvmm1TLO1aLu49ds4JednGmpfJ+vK31TwJ2sPTPQOL5sDVFocc3zb1BwJOdbd2qlOYBhDCzCBCTmWwAaKw1Dmi1Yz8B/96rEM/QZY+pREP9QS4+GKdNGZXAe/LxUicIymgnxrJl0/jJ/hPLtbAkBdn8yR0hYHtukiBZTUcUADHMvi0bkQSwHRJptKkjXpJAGYGoC4c5GMalVZkA5gvKqP1TBtTdO5TGPnZ8Z6SCmrmrOVWe2CPY/e/5kRlR7t4nrlWNQ2IU9otxrkubpEBotSNJtRK2gUBDeLbn7OrRWFNpXchZQLDOBbS798RVgTUhvU1jfvpirauhDJY9k4Y79+dOFfLk8zilgtGcPmYrH1lXAAMqIEU/MMvBOJeQylToK+IbGeESwOW72ziqxKiDCraa87VQL0lZ5SipqlM65ck8sDdzPw1QnOOq3f6lGsAaWC3Mgz2viiKZTy1QGi2xNFDRuigQD6r+Nvzq9WleNhrrN+xWwyNBIarWSZX/uvaCiVomz6mqaWfHAGbYot3Bs+u9Mc6ztmZQlfJD4q79Dtg8oUdrGgPwRi6kOcxt3ITTMc8rcSEoCsuFMRDgJmrXriOb8T14hVFUNYnM9hAQlz1puk7Dv9WNOc0pqxfPbSDtWqVibKD3wllQx4v5AIeZPEdBea5s4izy7De3ATC0r4Agqb6fCHeAHqhMh5FYXmD4rxiZ+QLZh3FZ9g/qzC5Ivsi6R75GoTrGWaFrABsHUQ3ALOMp1DNFPkTZY/uIbYIR8cHeeBjyDfgd5IcDRIjy
 PQ+nsirY
 DPqPCk/PkYK4qKWd+jVKm4+utqN+SvAZqqqEKPbKlkQv001ma/ES0emcHx1f6OjsnBfAwaMQ1VnCeOrQfnsDw6ME/pytbrGZp9SoVqy2w3GGPfvq8ZcpiFV7kJxv4F9EAKsRHScA4pxPTmzeDWmZQyVs7b9D0tefN8aozfXJJHIdLcklF0IgLPK7P28poah+jiAwenP2IRjVGAUJYyyz+OKepS0N9gYgQ5DY24E+wpr8UdvrVYOeciBDQ2Th83IerTmRKY1wkdHqYuvshHEZaIKv0BAbsCI/jIv0ag1tnBeqKl92/rwHI55kK1V8mxYShbafRnZTYKDPyI4CWj/NlcpU2zHsafhSL+KQQHIABbZUumwcOy+HQk8JucQ1685Z1/KAgeQ/Xt7+oTMvutbn1r2yhKIWVcywYtzpP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/20 7:30, Lisa Wang wrote:
> After modifying truncate_error_folio(), we expect memory_failure() will
> return 0 instead of MF_FAILED. Also, we want to make sure memory_failure()
> signaling function is same.
> 
> Test that memory_failure() returns 0 for guest_memfd, where
> .error_remove_folio() is handled by not actually truncating, and returning
> MF_DELAYED.
> 
> In addition, test that SIGBUS signaling behavior is not changed before
> and after this modification.
> 
> There are two kinds of guest memory failure injections - madvise or
> debugfs. When memory failure is injected using madvise, the
> MF_ACTION_REQUIRED flag is set, and the page is mapped and dirty, the
> process should get a SIGBUS. When memory is failure is injected using
> debugfs, the KILL_EARLY machine check memory corruption kill policy is
> set, and the page is mapped and dirty, the process should get a SIGBUS.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Lisa Wang <wyihan@google.com>

Should we add a testcase for hugetlbfs? It seems hugetlbfs_error_remove_folio() behaves same as shmem.

Thanks.
.

