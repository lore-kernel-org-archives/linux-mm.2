Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D7DEE01F6
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 22:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A3D6B0088; Tue, 30 Dec 2025 17:38:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7396B0089; Tue, 30 Dec 2025 17:38:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3DA6B008A; Tue, 30 Dec 2025 17:38:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 077C96B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 17:38:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AACE160262
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:38:15 +0000 (UTC)
X-FDA: 84277602150.17.456D4E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 04CCFC0006
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:38:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b2cOJ8YL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767134294; a=rsa-sha256;
	cv=none;
	b=1424q8oTsN8PHHxYV4lMnCiZ6Q4JZizjSMdI0nprACeujjn1AS6wi3FlIMGz/fRfNoKSK2
	1L9ijQq4HRvdGaazDhEi9rsRwgMeTKZpg781lTbE1Q6BS1B5T2+TKEEdWqVGukpEWRthr7
	+lQ80pMT0gxMeamjhG9hluA4596zv3w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b2cOJ8YL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767134294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4A5MkkssdopRAR93WJD4DYIHbsjcxApDg+nSlq5QCc=;
	b=Otw0xlkTRI3jvMDXYPvDiSBYxYGsvHMUm4ii0TTglUJ6Kq/dlTeBR4ZNTsxRgPf/uc72IS
	h+vHxTj6GFdz6PfnZUELwb9VJn7LBKtL54+vfkBumZ7m8F+nk/A9m4b/XQvF37qhH3cES7
	PhGUo5LgLnp3huiumzkP3tTj5VryctI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3876A60017;
	Tue, 30 Dec 2025 22:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69369C4CEFB;
	Tue, 30 Dec 2025 22:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767134292;
	bh=Tb3tynnxxnwuANiHqkonp4fihfVrESQp6TRTMLE8/iI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b2cOJ8YL9H3+tcxp0RAQnc5CQYnXPXOwJghUPMxwUA9nJ6+jdDVbBaf+CVtGr49mj
	 NcFoZvSde20KbB6f29qNdHoYvCrrD9KXIKSkLSESSZU3CeFKhgKvmeLsIKz36l3BDv
	 ZqHDMjOeFqTCfC1E3RRn+MqTIhX3ZzoVKL9GVwFxgm5PZpPnoEShKS6g+GEHhM3T5R
	 Ak3KCLfwYwDPNgJrx7tv306BftuJfE5/umRJJVfDTi/6tf7wCvTJtzXWSTNibia4VO
	 e+wO+Ccg/vgWi85o7qxny3KxKBVON1mdMm8lbrc3w/6NSbRmm//YBotNrxpr9frRna
	 8XuNauqTZD6tg==
Date: Tue, 30 Dec 2025 23:38:09 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Zhang Qiao <zhangqiao22@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 01/33] PCI: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aVRUUXa6kJKHHQ_n@pavilion.home>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-2-frederic@kernel.org>
 <e01189e1-d8ef-2791-632c-90d4d897859b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e01189e1-d8ef-2791-632c-90d4d897859b@huawei.com>
X-Rspamd-Queue-Id: 04CCFC0006
X-Stat-Signature: wu5oi7c9dx3h65bnu4qyfpwoqewcumfy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767134293-796820
X-HE-Meta: U2FsdGVkX18T8WcY0CofWWn0xaLz2FllPvStNY7oHfzbIRY6Aazf/pnD7/8V6eVCX3GOt5y4savd2116dmvPapd43rsE9TcleP0MnqbsaVbOpYusaDEjuuW7+DQJDIIG9hKbrubLfVNFM4uCPHsPZUGIjUEqtuD4xwjIN4wGXkFDKMMSkFmTUWFSFxh6x/Pu/FpxednnK4F/ATjo74j7R88ggdRxBl+3CPFdjoRafm3LjazBzgzYzawc9J4ohrvhXeb3LDZUI18k8esrPUzRYcXcC1oDJlSo148JcyB94sC/wVrHwLfpzHgTmJoyf/JtY4RHCCCWS7KE3k0YMX2bRL4EpmSLkAiMyQSkjTFuxTXWU0BpVN5I12kvBF2pcFZWqn26ffkDVEU4CRlHwZpU2S2OykwahnAKLgZP+McYQwt0OL2sr/qlABz9+RVUz7i0WoxZvMZJGh/p0uMtVlxvBzfIGaboi2j7lJG0K7P+z4rjoP2M6axvo05a5MLORzWeY6AMUHrN7tr2T1shDFJRouN55Pj+vJ5M4Lh0JjbXHeEKC7Pw334fNj0T6iYGw7nhxAo/UAL9rReZYdWPALBt7101Lsfdnms1doz4KA7364vUm8itw9RlIP65tzuUrZotqpyF44F8b+K9y3kgGZ3Tju2M8jXME74ewV86dNs72f0ZCaHEbk5/e6UPnryo8lH5qIHsXuEFNG5H9vofpKa9QFhtrq/aYrfG4qnY64My7k7ENOEJ631tnfbLIiN8YVr4dnGjce0Rt70fHksApYhmBtMORjIE1BtePuvDolAfwL8cWQmMNeWDzixMq/iwaN9aP0/u26nmQN2znRKsZVf108JkpaCLPPGBHHnRmj7fRW9HAF93+ciYqd2L+6VHCKbTtC5VXUj961tneFhAM2vRzU4qn5asck7nCZKz6JxZ6yfBxHXtf252aese43u2KjNYtUcHPHM62npkVr/cXd/
 1EvpDOyM
 97KLJj8fMo0BipDIZg7Ht0/dU4IOPyGCllY70ETeWEGqXcPdCjrF0HTlw2EoHL5cGPtjucyLRxRXP28z862ueOh1cb2Ke1PS6LNfzEMjOj8yXt4tuuBA95A98aKIlRpToPcqDYxpnZdesq0agQatlxEWEMrYNLx6jI0GNeX3u/iY9RRqZS34GlaXn1R/6AhUy6hQ+SkTleRt47IORZmSHFHHG5pti04WatNPoFEibKSKQHRFygHvXObIwdOr3XKdQSp4P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Dec 29, 2025 at 11:23:56AM +0800, Zhang Qiao a écrit :
> Hi, Weisbecker，
> 
> 在 2025/12/24 21:44, Frederic Weisbecker 写道:
> > HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
> > therefore be made modifiable at runtime. Synchronize against the cpumask
> > update using RCU.
> > 
> > The RCU locked section includes both the housekeeping CPU target
> > election for the PCI probe work and the work enqueue.
> > 
> > This way the housekeeping update side will simply need to flush the
> > pending related works after updating the housekeeping mask in order to
> > make sure that no PCI work ever executes on an isolated CPU. This part
> > will be handled in a subsequent patch.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >  drivers/pci/pci-driver.c | 47 ++++++++++++++++++++++++++++++++--------
> >  1 file changed, 38 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> > index 7c2d9d596258..786d6ce40999 100644
> > --- a/drivers/pci/pci-driver.c
> > +++ b/drivers/pci/pci-driver.c
> > @@ -302,9 +302,8 @@ struct drv_dev_and_id {
> >  	const struct pci_device_id *id;
> >  };
> >  
> > -static long local_pci_probe(void *_ddi)
> > +static int local_pci_probe(struct drv_dev_and_id *ddi)
> >  {
> > -	struct drv_dev_and_id *ddi = _ddi;
> >  	struct pci_dev *pci_dev = ddi->dev;
> >  	struct pci_driver *pci_drv = ddi->drv;
> >  	struct device *dev = &pci_dev->dev;
> > @@ -338,6 +337,19 @@ static long local_pci_probe(void *_ddi)
> >  	return 0;
> >  }
> >  
> > +struct pci_probe_arg {
> > +	struct drv_dev_and_id *ddi;
> > +	struct work_struct work;
> > +	int ret;
> > +};
> > +
> > +static void local_pci_probe_callback(struct work_struct *work)
> > +{
> > +	struct pci_probe_arg *arg = container_of(work, struct pci_probe_arg, work);
> > +
> > +	arg->ret = local_pci_probe(arg->ddi);
> > +}
> > +
> >  static bool pci_physfn_is_probed(struct pci_dev *dev)
> >  {
> >  #ifdef CONFIG_PCI_IOV
> > @@ -362,34 +374,51 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
> >  	dev->is_probed = 1;
> >  
> >  	cpu_hotplug_disable();
> > -
> >  	/*
> >  	 * Prevent nesting work_on_cpu() for the case where a Virtual Function
> >  	 * device is probed from work_on_cpu() of the Physical device.
> >  	 */
> >  	if (node < 0 || node >= MAX_NUMNODES || !node_online(node) ||
> >  	    pci_physfn_is_probed(dev)) {
> > -		cpu = nr_cpu_ids;
> > +		error = local_pci_probe(&ddi);
> >  	} else {
> >  		cpumask_var_t wq_domain_mask;
> > +		struct pci_probe_arg arg = { .ddi = &ddi };
> > +
> > +		INIT_WORK_ONSTACK(&arg.work, local_pci_probe_callback);
> >  
> >  		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
> >  			error = -ENOMEM;
> 
> If we return from here, arg.work will not be destroyed.

Good catch! Thanks.

-- 
Frederic Weisbecker
SUSE Labs

