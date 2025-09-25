Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE4FCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522E38E000A; Thu, 25 Sep 2025 05:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3868E0001; Thu, 25 Sep 2025 05:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410C28E000A; Thu, 25 Sep 2025 05:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 311298E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:34:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E24E1603D1
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:34:33 +0000 (UTC)
X-FDA: 83927262426.25.8D648C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2ED724000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:34:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j9C1R7dT;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758792871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsqWIMgXNh+XoIi8h5OXkdsE3PTVEf/A55fR6b7S5b8=;
	b=I0QZhzO2ewXvH70ZFqNvsUPMgRPr4bls6H7BhIAkO1i8luNW0tOpopPm6aLxlVFeBpEwtH
	SwGOQ2IHh+2J62oGQSuABl5+hvpvOfT97p5Ph671fq42xnRmGT/zA2tzAZpjEp2UoE6t4u
	jFybodZvIPM8ZOl12SZujJGmt49GayQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758792871; a=rsa-sha256;
	cv=none;
	b=Xwssxpr4M/vmW66Zj8HMCL9dwckqYQmNY3Or2jlhQtj/8t9UhuI7VZewFQI1MTWUKPnnyV
	3pONYS6VlYijr+y48sKvh0uFVP/IcvU06mcWDYp/lq/7TSDTHUm//aWxIDa9HGwd5kiNpM
	fTCOjXBnagmePXmvDNZFi7ToeSMO7BU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j9C1R7dT;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C040A43DCA;
	Thu, 25 Sep 2025 09:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D08C4CEF0;
	Thu, 25 Sep 2025 09:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758792869;
	bh=zhLCyo5R7EKVDWnkns2gJ5vK7ZjyanVB4ZoLdpUCNSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j9C1R7dTphqDn936rCHEjvRdwp1C6POkkYrek+iR0jbe0WP7/KvUswV9j3pvP1Qfu
	 L3WSYVA5WXLdVBthtQVsSMEzCHT6sjwyhnIkN3b/rCNQvAwE3r2IVzHQKGc727LYaW
	 vLFHnSIeyVM6WZxtbHwyNAByS1jrPpmH/vLsi7lXUpbqtboZ50mFJ1si4fIFbetccT
	 TM9Sf/13LEgKptpT3pjaWkR1sLsFPBR8UZY18Ittvsl9LRcfmwiW3HjrOP+rBVMR15
	 6nm5DCjweITgPz6MKF0N7alTBx6yt5GNhpJSfEyi82kHOW3Bw+bzoDbm0g7z26/F2E
	 ccH+/s75kvIAg==
Date: Thu, 25 Sep 2025 12:34:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH 1/2] drivers/base/node: merge register_one_node() and
 register_node() to a single function.
Message-ID: <aNUMnK23qKTjgEdO@kernel.org>
References: <cover.1758736423.git.donettom@linux.ibm.com>
 <40257b5228dec05e5b252f02438608eb8d681a2d.1758736423.git.donettom@linux.ibm.com>
 <0de65980-4333-434a-ae7d-2b7be46c2cca@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0de65980-4333-434a-ae7d-2b7be46c2cca@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2ED724000B
X-Stat-Signature: r3957wwe3nm5w1e8gf6w9r9sjhpi7ixk
X-Rspam-User: 
X-HE-Tag: 1758792870-595271
X-HE-Meta: U2FsdGVkX1/2HI1HFRwMXqQyf8Y34spTvsem/B1cwPgneFMh/ezJB89+fvbY4lCqSXLAmqY7sm4z86qrWuf8J7Le0usAO+DEPYwGzmiR2J7bqYH1aCTtEVnjd38zpPicn8TosikmIRR+++C+UiOGb8ZHuWerzJ66t8oov9ynHwqXJFK29hFpaF2TuQPg8UcynjLTm5/SApWbiUL7i7SRInfzBxu5DM3fBaMAKKpaVZsWS0Q8dmo98C4gZzPKsQyiJJQNQCYIBbmxnXu4UNaFc6z+C7oraoiRmKSWl6t2iuDLxh5J1dLmOfZudvLnTu6DVgLCedeyM/YYEo4OxqYhqTT5M4UHXVzAbcoOYQlgsWu16YFMv9gICczayNU5v/XFo1aNT5AOXEfDT7k9fwRFM5YskyoS9yAC0ZVzaGipTPb2ImY5jDw/PloON4cWc/rYsnlvDijPwFyXKpcvYBnRcmNt08BeIK3ehtO+Xb9fCcdmDMNduZKeTs0nIN4FgH7PJuCy3BaCRLXgjFVThCkkuBHeGIN/139Px2DoAQ6fLvEdJYIXadHOf60l79RwzHzr3PhANDsF+BeNVDhc4K/DD4HJT93OlDMHPt7khRL6iE7Y5t9CK6LeEfghQM+xfYpjf+MDjUdYxGT85bqpYxPo2Y6ZgGJITIfhCom01tHJg26SG0C6RvSXHCYpGS6wF4wEiWfWZ94LEHXa6wHXaNqgnbPgATZDG1Ujhc5ztQt+8X/56tOFDpZHZydgNamFyNC9l8RSswDS+Rfauk5rCv52QlQAnYsYByXz9UZf7rcHYRIGpOvYD28E1XIfH1gzwm2n55cCNV4TSENc6R8L+GGIl2kjr6OMgQ7FgCtIHQ8vffTFsngnD0USBfTNry2EhHOjXn8kS3wZilOWJrLoXUQ4xmGGAM+bgSMlrVEreZuUmZmEpvSXJmwmZ4fYILeKwYmNRHAyxYlr51vMcIjdCfl
 iQQtdth5
 zuceb2TsmIbPunjE7S/fIca88H0erFBaVoaiOQTy0+jYyeWNQ5X7LBtEBcxARXPCwjdlwet0ifBnhaQPGvnh0ZFCZphX2q5tnvfdbqay81G93ba6MD4GV/jajlzr0d8G+VcgDY0D2wzBXfxJ4fwrg8DHEQOqhRdEtQM00X6ww8q74GqD5sOpAmKra+8SeOQAqHiJnttKBy95fs5hclhamapoXCLEGqsf/a9QBsFntBv97iLShq2Ti0XVhlmJ3jHoczQTbS9zEuWFTyT8xel3uavoPRvEClRvJar3PKkvck0XIYZiRZxaMncBQdnd1BDQmOnz+o9xJfUqsHj292d+IQx8Q/uJPip4mty0gYUhUwS4GaZA2D2BJu+ttoiOj142MMDNx3Pn9v7eF86Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 10:54:07AM +0200, David Hildenbrand wrote:
> On 24.09.25 20:40, Donet Tom wrote:
> > register_one_node() and register_node() are small functions.
> > This patch merges them into a single function named register_node()
> > to improve code readability.
> > 
> > No functional changes are introduced.
> > 
> > Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> > ---
> 
> [...]
> 
> >   /**
> >    * unregister_node - unregister a node device
> >    * @node: node going away
> > @@ -869,7 +842,13 @@ void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
> >   }
> >   #endif /* CONFIG_MEMORY_HOTPLUG */
> > -int register_one_node(int nid)
> > +/*
> 
> We can directly convert this to proper kernel doc by using /**
> 
> > + * register_node - Setup a sysfs device for a node.
> > + * @nid - Node number to use when creating the device.
> > + *
> > + * Initialize and register the node device.
> 
> and briefly describing what the return value means
> 
> "Returns 0 on success, ..."

For kernel-doc it should be

Return: 0 on success, ...

> 
> > + */
> > +int register_node(int nid)
> >   {
> >   	int error;
> >   	int cpu;
> > @@ -880,14 +859,23 @@ int register_one_node(int nid)
> >   		return -ENOMEM;
> >   	INIT_LIST_HEAD(&node->access_list);
> > -	node_devices[nid] = node;
> > -	error = register_node(node_devices[nid], nid);
> > +	node->dev.id = nid;
> > +	node->dev.bus = &node_subsys;
> > +	node->dev.release = node_device_release;
> > +	node->dev.groups = node_dev_groups;
> > +
> > +	error = device_register(&node->dev);
> >   	if (error) {
> > -		node_devices[nid] = NULL;
> 
> Wondering why we did have this temporary setting of the node_devices[] in
> there. But I cannot immediately spot why it was required.

register_cpu_under_node() references node_devices, so that assignment can
be moved just before the loop that adds CPUs to node.
 
> -- 
> Cheers
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.

