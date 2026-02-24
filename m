Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C537EF5862
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88C46B0089; Tue, 24 Feb 2026 11:54:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D266B008C; Tue, 24 Feb 2026 11:54:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE17B6B0093; Tue, 24 Feb 2026 11:54:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB26C6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:54:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73E7A1A0252
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:54:59 +0000 (UTC)
X-FDA: 84479949918.25.865FDF9
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8871C140008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:54:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nBjl7c6d;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771952097; a=rsa-sha256;
	cv=none;
	b=wSb+ztEdKRGg9T1IZnNt18OpwwlAW/GHBPp4eFBnHA9cu6VY7n8KYNyOXnaFeAswLfGLRZ
	F9gtZSX4Feq5lccnZgzz313MLXYCF8brGsejL3b8pL3A2tDGgzr5M8akgtd0gODmmc71Qb
	9Ifs0HteLbfj2uzpvxn0N9tuY6E1DlI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nBjl7c6d;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771952097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/u4GoWFznFuQrqLlGOUj7jRuDM2CBLv4iVo/JzLKZig=;
	b=8gOX0TWDyxzAUrTxLqTg4srKE7fIcP5bw3vrkeJt007fcUumLO2lV/FVB9V+njAotYrhfs
	u2PeSn+pX9EITfKjVvOP1ojbDbWituAvzH4TfVMcS8ASbob/dGVhdpdxG3gHgwdy+9E7Sx
	tXumwzS78iVnvmd0uT+pQEo1g+Iub1U=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8954c9daaeaso72513836d6.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771952096; x=1772556896; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/u4GoWFznFuQrqLlGOUj7jRuDM2CBLv4iVo/JzLKZig=;
        b=nBjl7c6dol4dsbMfE8OffP5OPA4Klhoi5gNY+9RSaDKpAo8IAp4rIgc8qA0AXHZl9j
         SCRis5sEKfuLfT523wCtp+vpa37LlwGE+tQitlvgfwNUbtBohTb+p0NzOEovrOonFHYQ
         /d/ge0eJq8myY4NL7shxroew8K3rqNb0bzgb9tNChMLSQktz6Rt0NXnTSrK2LGgZb0By
         USWKlpOsI+sBSdCbLfajKIY46FnN8tZ7z0hN6xJSHOpRftchy4mPXF+8aPCHXfr6RwVH
         +vSBLc+jZgU0wDg1nHL08EAtEbvr/HZRORN0xgOmjh7i/pcTv5tYPywmAfG01lFi2UfF
         Eb9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771952096; x=1772556896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/u4GoWFznFuQrqLlGOUj7jRuDM2CBLv4iVo/JzLKZig=;
        b=oFMP3hYDSn5BPiPIfoxwR6lg6fR5ykgGH9mINmgKru5SROruM6jZOmZHWlkJja8EKb
         N5g0rCJD5gfp5elSyzRQTl31AxeACBTD5xSBdj+IFEPTa0JMAcy2F+cyH0y0APvsn1WO
         1Tas2f6v9XGZm+pQFVpWY1iyT3zYSAmsce5p10gby2b0woIukk18SkH2vBgutdynD/rM
         E/GitHrdTxDiqOaavR9/asuBaL3GTFg0+BJFZc2ILpsF6ri4y4LOb6cGA0FMG7S2CLps
         QH79ielnTIDnPwfHI24feVmpl7/8gukVuXoLNnMaY4A7HWKIoiCgWBl3Q/hh+n5QWNDM
         0WoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSt4SSKOaOSZ6v5bOyKdoay+++1OL2W1MwI+mGE7f6CLP+mcl3LQ315A/AUCT2iF/og0rx0xTh+Q==@kvack.org
X-Gm-Message-State: AOJu0Yz4XryfWRJ/VvQZCXUKKJGqsLXZ4Kzgl9XMWm8/losKZol3qYI+
	JVcOc5FBwuyR1KsBH38XMAF5mv/FbdI/368QUD6FjHXzXCDaecKJTDE1XrADYWXgMXA=
X-Gm-Gg: ATEYQzwso4H5EEddhyx8E9Rt3jBxz5F2AAc48jQav7QOXCPBHAqqqRQwtbRzk6ZsGt/
	o974uAosol9FJb/tMNIOsnFucj1w5qTi1EqUhqHRyj3uIpB1PKyIioSi/oSaRqOAGasI4SXRH/4
	5c8c+TImHIv83M6GGIS9EDGb+8shuL7PF0MwR/u+i/us3p+xtu3HdSxH8Ob//4eZwuVUxEW2km0
	5UVOkodenTHWUXWTI8wkeAGo7NL39tpbvRVdY6VOSGZ5hOq3iDVXjndjXHXKBxCKMS0hye3fT8+
	Jn4OBK00+X8WrB6+f+FxPYy+PH2E9q0dXBtrbRmtHF4k28XuymUdTr0kjHOQaacYlyK6CkBHnTF
	9/IPC3F22BSXxg/Tj+aagzsceUx1DQ36KzKumbA2lSvgTIMGzE07KHQOaUUR5QXJ5TRTQPsSBor
	9ppF1hgO1e8L9fm5WE4sQfFMu1Ofj0Fj0Z9vDlF4Ze3VxEwfuDI4B3gfCrlErc8c1j6jHh2HvLt
	VDAqfcZTg==
X-Received: by 2002:a05:6214:1bcc:b0:893:4efa:e8aa with SMTP id 6a1803df08f44-89979e317cbmr188639836d6.9.1771952096264;
        Tue, 24 Feb 2026 08:54:56 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d0ec694sm1029766685a.29.2026.02.24.08.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 08:54:55 -0800 (PST)
Date: Tue, 24 Feb 2026 11:54:52 -0500
From: Gregory Price <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aZ3X3Jni0HZXZMVl@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <fzy6f6dpv3oq3ksr2mkst7pz3daeb3buhuvdvcw4633pcl7h6u@mxjgiwpg5acv>
 <aZ3BEn_73Rk8Fn7L@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3BEn_73Rk8Fn7L@gourry-fedora-PF4VCD3F>
X-Stat-Signature: pjnfuf17ieemuua17apr9gssrcyu4rxn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8871C140008
X-HE-Tag: 1771952097-59499
X-HE-Meta: U2FsdGVkX1/VkNPncRwPlKKZvIT3ZODbrkn90OXh2Djt6fVuxT9byu/W7o4R2EGcaE0HPzQFKJBm3rqyLmvdtMUP3bUle6HcbKVYIA+EpDgwUIulGj+J4ejcvUHbtSxVWAiuFqKy5X/SNVcLKZvREJfaUcquYB7Nn3zqMjvo/gzuCIQhblhrWN3qt4rG3uZlN4MhHmBQBhnmYTp4KvHFdF7+EAn6c286mnVt/yEBsiJ2or0X+kgtDdxMJD7VDDbzHAaas5Zw/0YpydcUGYqSNxpB210RPme5oY56dY7NE28jSPb6NOHFp9L1eiE8bn84Hsf/2KzUkznTibb2/BA/N+aUL/ogravQSJPKry9yYScLC+jSwSnDmb6lRShehb7uNql3aQEpdby2Iwww0pc2Zdk7F3qEF6x+9rjDl4ae6pTnqJQAFe6nlJlLewxht8PGDpy4WSMua9uL9RqOaNOv1zK3kjokyKuHDveDJIGIoLfzH+Djbzu+fho9k5g1Avqj8I4ALWB7821JxuK5cVHXiX1dE8AIXPrkFoKK0ZOZF4Nju1ekZsN2kiJxvZdXnFF7JfPBWKPYp7MW5s8ZKvb44Tp2/1hzmyJkMlHSLNawzocLpOJEo+1yw2qAhLSpGFw3hpO6PwiZtRUjsBynr9aI8PYGz7vLvjy/8iLGDQHKcG6XO4S4gqSSZGPgPztz66ApFUbsRo5NdWq3+hMinYkbSXTo/Ig6qEFCG/X33mX2VyMBpL15/nH48MsIFeBCjDoFNzLRce6JwAtygjsqkEpUguwNz4M8pAeEfJJE1xbNJm+whmfyauypu8ArcHmmjWrcJR578u+PGEGqox2TQRSGuY9B6KSTbBv5obbkcIVd+LTe2ICvWHdyAVVkdJUmZ7vvxbhgP+I5sefww/MLT8/hIvifA8k2Kd9mH5JkorEvBlQJ7o70EDeN6gxS0+9FZ5vhG1Ldw0nA6Kt6EpkCYkH
 Rd+LH5oJ
 zPu6VcysRswmH5Wxm61oAyuEULw/DkmJ8CM17+jsjkjDPwCjOaAAexlyEXZWrhZ6mqekheUXUxPghA9czi0DRaid2bFiOJ1HaEV25u2IkVTKlaZxrem+aTxAy0PO9lP4Q5Cvm0m3e71lgQ5sG0gkUhW4pGtfIkZlt1r+9/AuoyHNJVLX07DUbooeQgaxAvb/ItR4fNcEDx2iwZvkDNFEJNdDZusYj5pIZFntp6/W7UD75pT2nBY0yaXTWYmYRIYrI74+8KZtJ3EDlL/DJemB19b2713kMPLQNz7MXEAOYetvAbSxVNsPLB3qIrCbZYAyZ7utqjjZZkN1FdUMsqasLebF54T8RWlseGtoh86jMSP483TfC+hp6cIxSxnzVT2R7k9HP0NE9IocTy82QeVHtbh+XQ+3GMik7VtQcBtOIV1N/rck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:17:38AM -0500, Gregory Price wrote:
>    - Changing validations on node states
>      - mempolicy checks N_MEMORY membership, so you have to hack
>        N_MEMORY onto ZONE_DEVICE
>        (or teach it about a new node state... N_MEMORY_PRIVATE)
> 

This gave me something to chew on

I think this can be done without introducing N_MEMORY_PRIVATE and just
checking:   NODE_DATA(target_nid)->private

meaning these nodes can just be N_MEMORY with the same isolations.

I'll look at this a bit more.

~Gregory

