Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F194BC5CFDB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 13:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE4D66B06B0; Fri, 14 Aug 2026 09:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D955A6B06B1; Fri, 14 Aug 2026 09:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86A56B06B2; Fri, 14 Aug 2026 09:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4B306B06B0
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:27:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A6DCC011F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:27:20 +0000 (UTC)
X-FDA: 85099951440.08.080248E
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C056100004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:27:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=USO9GcAc;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786714038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4ArN/eG59F6/a+Z1l3n9inh5iDgTQHyg71JvETU2wM=;
	b=BFbTR9LoBVQLiN3wHkXticEI/bt5xzxiMp9+O0Cc5aOOsvrliU/MCVy3MxairentRDB1ON
	5onsHKEmFLIo1cVL25HSd/6xer/hKoKSV4rZ5KowVqOEi82LiYmXxLSQUmBBR1IMGkQXwx
	9dqpna6RDN1fSin9Ie5r7+1bgEq0aNw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786714038;
	b=isvBmCPWAEVcWLIplu57RVP/U2n0d7OM+a5lDFVcY3KUTzt7cg9NEwd1tVkDOEcnUeUSQ/
	bnVhdewR2t1TqtirFcUF5Vj85Gn++1ChLMcQq6UDEWNzDen/08jIYmTwju5jAiA2qLQxCw
	ga+CtRReYJnuMRSNiJPQNFKBGVJrjbE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=USO9GcAc;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6689f36ae56so1690546d50.3
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786714037; x=1787318837; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n4ArN/eG59F6/a+Z1l3n9inh5iDgTQHyg71JvETU2wM=;
        b=USO9GcAcXSDYmDWau8YNfBqvjEKaHg2zrWV06qd09BlXWTAmFJVUt/FIKLrMQ9Kbnl
         BvRZbA/0qk5zk1VU0F2uAp2cIY8W7N5gNL6i49to5hKu+fi2gFwUH/Cd2aIh9qdD31L4
         b9K00mWdz37qa4zrIC3Yy+wT0IKW/usG2L8OdT85BM5L/q5UECntt2xFZb+ZQjRUqmqF
         uw/ibhV4hautXq+RRTKYJj7+DSSW2cn+c0hp2cYrJrruzbtLhk4MJPTx4YPDju4lX9ak
         hQJhmbe43YwNjFsx0kVeUa/fdBMBJE+Jli/MyWeBmsoZ2k5C9ITaBpuB8BFDupUIZJeZ
         pF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714037; x=1787318837;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4ArN/eG59F6/a+Z1l3n9inh5iDgTQHyg71JvETU2wM=;
        b=qNkW4Ga8PjCG9/uAVFTqXZf73vu6FCT22MKSfafYPuo268R0vpMNiV0wZ0sRkLLNEh
         KMUnvpXxOW3fjr56hfSkvp/AYYlmIqwWBi/bMh1ZSNRZqGlVeEDZWmKyD4WkmxLEuwiK
         1i6U+NfTvdOtNkrkaRHDSGc+5JgyDYcaTDxPt4iDQWN9zZ3DPwDw2KL543pgyNzhJO19
         UH5sLUkE0ar4iOf837+wRMyS7XXLXPb/Rd0KBfpNrNHX65Po4rAyz0AnFR5pMVD0SP5O
         8w8/av1TrCthmJcpo8cwQUubvVkTA8gJ/26B/hobFJKB5Sa/Ac+LyVKDn2xR9aPWuuLD
         mqxA==
X-Gm-Message-State: AOJu0YyXIjVRnmp//IZeQC7uIBzBrvHlzxtHZieCjRLSD6kzbQPhtqD8
	xV/l6DZ9J5EMSWE1k6eN3zXOGyfOq/V+P+HmjqrZ+czmGY+T/L/L6OEBqNToyOyXN+I=
X-Gm-Gg: AR+sD11iiIGHEFoSK1Vx80O/tvvMCkktxoySxiF4SVag5fGaiycmCu0s71DUFXjn8ek
	trNWv9+PGIwUm0RzxIobT7DQzX9S6DOaGUmIEP7su8NnaUzReePUqDxMkHOF3S8d1+FlSaZxtzS
	kdVRC3KqfmxiMWbn4J1BzUYLV3i8RS5TnZU/hCftzs7qDqPd/zUBIc22rnOFL6KOfDzfiM4LcJK
	7eEbHJoAd4zaNnuyMTTNdTRAY3ao+h8szfhDMaeLd3aePZgj0XLCKPG57FJTeZ3bYO7ZJ0CZ4kO
	6gh+n0vZgxqqbSrTRCdYrNFSb5qrMCV85Ipvj7F00vevvi8NNYiYOMlwn4Vk9aHwljHayhYZ+5v
	gvztK6P99ljn5I6opftV1WfOcRIIgudBx0MtSrJ0uQHlJYDu6MgQuHZ1E87zQK1jerQdnioeLzN
	l2dSTH5XmCmDTJ8bK0v8ch0vhuhHQK32WyzXg=
X-Received: by 2002:a53:c584:0:b0:66a:3662:409f with SMTP id 956f58d0204a3-66c72ba0d10mr1917799d50.10.1786714036424;
        Fri, 14 Aug 2026 06:27:16 -0700 (PDT)
Received: from fedora ([2601:19e:8500:d3c0::28fe])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66c75c9d90bsm1010793d50.8.2026.08.14.06.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 06:27:15 -0700 (PDT)
Date: Fri, 14 Aug 2026 09:27:09 -0400
From: Gregory Price <gourry@gourry.net>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com,
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com,
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	"Gupta, Pankaj" <pankaj.gupta@amd.com>, vishal.l.verma@intel.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org,
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com,
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
	usama.arif@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
	cgroups@vger.kernel.org, damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <an8Xrb5Phmvs0xE4@fedora>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <CAM9Jb+jpJ-Ui4qDHxsp2WiERiv8gmrQfKQ8Z0BmabefeQ6pg4A@mail.gmail.com>
 <an0cAMh_m8ZhGIm2@fedora>
 <CAM9Jb+jmxPdL-CdWQHYMT5G=qmjB6z2WFg+4K8Fod5n=2N6YCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9Jb+jmxPdL-CdWQHYMT5G=qmjB6z2WFg+4K8Fod5n=2N6YCQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: xguo6kawb15h8zsbbo41mkj8cobip4o1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4C056100004
X-HE-Tag: 1786714038-939326
X-HE-Meta: U2FsdGVkX1/Urt5oAo2QZH6y5oOHGkujmM6hMhqfilMrSVf2OCTTbNRb6zApoaJpQBKVCrwv75opUvefUzMabsyXk4UKMfE7Nu4Iz+F4Npvwnvo0E4Zl0qwYlXNIEyOHm1x6wnEwBFVPE79tOayiZq3cpxNUtbpP2rvseRZ6fKN90MtmVT0q7q4nlegaaP+2WJtA9D7rR4eyC8/3iFwmQimAB4xXKUCjKdrmWET5blCgT7t91MSN6f3rx+zDL3rATuin66p4nYh0jMnYjM6Iemri6LG+FYeVlZBx+xKSqHP+m/iXofWaRbTLQqYZ4CJ+I0TuVo8+ee4SlrPijAIa4buRdpNWIQlkFgvPbUOpecPZSDZiPDY+HVcABQlwfEyU/mGldX+Kq17hmGMhSndacmXP3pIznF4lGRDPfjZw56s75F6VfSflKdryCxtgX9Kt8arxSMyqJw1AGy/Q8r2MdrESzZ9BFBs6MJuQWHpfxBpdMtw4eDBcwsEn6JKXXIZ0p3I51BAv3AyZn2iYnx430U9XMywalLPHg0SudQEtu1/X7vur+KCgWDXq0NU55SanHe9eprVc3bK0ZjV6S/9kaSBBIPNSxfqy3IgNE37iu8zBHGBMhFzJJMqXCvdpZbA52uIsV3R5cxrkrQJZ0x/WJwyG1ro57ozk0Slmcv3AUqTt+F82HTztEaw57ksYDyRrz8VPqb638zI7Rb6d2XmO3otE680mrztkM4wy6qWjEAvKV49n6jty6rDMrKMPjk4EEX7fkgwQvevYrCrdmPGDYZaMzPBkjDPsmECN3JVjADLKVBQmiXu8cQVkH/xoPGWaIvg3tsffyscfDGDELdQTfcWZdrorh5ydXWQAzQGz3pCIrCWDd1WiMKZn4Geq1ynsVLFJGX9zxiYrKWjraMrHPvKuYE+2MsX54u61DfKn7A8DGo2GrbcfFoj7qMNv+9l9kAg2xCreGTKOY12Rv26
 V30QJIk6
 Robn5/c10yRITKtlLhWrgPkElFpvXJPsTwfR9GJdxFdYln3qrYxJWMNXNDJN287Y7AQJVdNGZAqL+G0aZgODNUhRE6H1wIG0ECNIApQXI6D0Q1QEACkimjccV+2mLTgzQa6/eofjjU6DrbZDcuf1eDQm99h7ECEPiOPRe4GAs4JzTrgpiqtQtkvgVmq7EfChiRXl7u2IQD7Orb8G91kAJ7hWtyiuKY7euakkCRAo8tQ9Y9p+SeLsc8Vc6bgt/Td1JdBuNJzaPiTmSMv4WurmV9IvVA5S+x8U6TrA+3/rauMfRE+tbVYtHiYTFhFvkHbwDlqaVqK8Uq4n0l28CpTNDwLzp8fPDn3JNMZZTcwmomIecgKUrtnI8KwI3d2U5UYn7WhC/zYcadqgNzUTAS1ex2jE9zNPi+JNATWrNa8amC3/4u30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 10:55:13AM +0200, Pankaj Gupta wrote:
> >
> > A device driver could very well just call memory-hotplug directly,
> > or its memory could be brought up as a private node via a boot
> > paremeter (which I have sculpted for v7).  The former is preferred,
> > but there's a bit of a chicken/egg scenario for bootstrapping.
> 
> I find this interesting as this appears to be evolving towards a vendor
> agnostic framework for hotplugging memory directly to private nodes.
> 

Agnostic would depend on a common standard for such devices.  Otherwise,
there is still a need for per-device drivers - but hopefully the
interaction itself can be generalized.

> How you see this working? In particular, How would the kernel know which
> memory ranges correspond to HBM or other device memory?
> 

Device marks the region reserved at boot, driver hotplugs.

or

Device marks the region normal, but boot param sets the node private.

> Please also CC me when you post v7: pankaj.gupta@amd.com
>

Sure

~Gregory

