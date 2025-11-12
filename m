Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C180CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 02:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8B738E000F; Tue, 11 Nov 2025 21:12:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62778E0003; Tue, 11 Nov 2025 21:12:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99FFB8E000F; Tue, 11 Nov 2025 21:12:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86F008E0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:12:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EB7012CEF1
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:12:31 +0000 (UTC)
X-FDA: 84100330902.24.AA01251
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1EE4C1C0005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:12:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762913549; a=rsa-sha256;
	cv=none;
	b=LYzZNGvpiMCH0afYzLD7bM4BQROrfMRAd5t7hhv1R5TccUEAah3X6QDEauG1xKgM0Bdv2/
	/0HTjMLThIeiQPJIv6fyH8M9AjJ27+eWjDj3o3Aq3cIEsvamtohml2qSHqBkPBJT2snJX2
	4Pea2yy0db1pXBbVsVzR0NJUsPSVeIw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762913549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tgwm1UZlu5QQozaSvtVb4DK5s4diXlpqJBehHOu44fk=;
	b=wPeQhVUX+CZkeDKL/nqmJua1xsuNkV4LYTElM3BuOOssfB/sk3nDzOHMWUvyPqogpGK6R8
	93+mppRYLdWwkFlYfnaQZZbBvF88A2SweRA4CBegwPgI88X/ueaMepcPuFAFRL59v1oQq2
	VTjfkaC3pX38K/0NUB0aCiF11T+gIIQ=
X-AuditID: a67dfc5b-c2dff70000001609-03-6913ed06a8b5
Date: Wed, 12 Nov 2025 11:12:17 +0900
From: Byungchul Park <byungchul@sk.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
	willy@infradead.org, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, gourry@gourry.net,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	vkoul@kernel.org, lucas.demarchi@intel.com, rdunlap@infradead.org,
	jgg@ziepe.ca, kuba@kernel.org, justonli@chromium.org,
	ivecera@redhat.com, dave.jiang@intel.com,
	Jonathan.Cameron@huawei.com, dan.j.williams@intel.com,
	rientjes@google.com, Raghavendra.KodsaraThimmappa@amd.com,
	bharata@amd.com, alirad.malek@zptcorp.com, yiannis@zptcorp.com,
	weixugc@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel_team@skhynix.com
Subject: Re: [RFC V3 6/9] mtcopy: introduce multi-threaded page copy routine
Message-ID: <20251112021217.GA45963@system.software.com>
References: <20250923174752.35701-1-shivankg@amd.com>
 <20250923174752.35701-7-shivankg@amd.com>
 <20251020082800.GA28427@system.software.com>
 <88ae0dfb-b10f-4829-8aa7-a681612704fa@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88ae0dfb-b10f-4829-8aa7-a681612704fa@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0gUURSAuTOzM+Pi1m21uuqPYKICISspOFGGIdYEQkFFmERNOeaQbrKa
	uUGwYomutZpl6vpI8VH5zh6u9kDNcq0ws6wtHymmpLBahr20h6tE/vu457sf58fhae05lSev
	6GJkvU6KEFg1o3a4Fq5mHW7KWmseQG51BQtviodoaLDvgZILYzRkZnQgsL2NZ2Gy+icNP3pb
	ObidZYDsLBuCssLXLLTezufg02gYdNwxq6DO2M/By4ZcFvoq/qigzXKdgaHBUha+mr3gvdkf
	MkwjNDh6MhlILL5BQUt1HQXtFV84uNhZwEJOvBlBfY+NhvHXnzmY+j4TmuwxU1BeEQ45j/o4
	f0E82/mLFXOMLxix3tLLiQW1J8SUxJeceKbFoRJvXvMWi+6NUGJtWTIr1k6kc6Ita2pGHdgo
	nk8YY8XPQ+8YcfxBFytW3+pidrnvV28OlSOUWFm/ZsshdfjTpC9MVI0Q15nWwBhRNjEhF57g
	9STRdJ/5x0WXJ2aZwSvIaM431sksXkXs9h+0k93xSpLSWEqZkJqncQlLSp+kzn5ww0Ek5UqV
	yoR4XoOB9FvDnI4WNyFyvuO5yulo8CLSlv1h1qexN7H/HqGcPo29yNXfvPPZBW8ixskkysmL
	8XLSeKeVmtutkic18fQce5Cma3YmDWHLvKplXtXyv1qA6DKkVXSxkZISsd4n3KBT4nyOHI+s
	RTM3Unp6OsSKJjp2NyPMI8FVQwbdFK1Kio02RDYjwtOCu2b6MFa0mlDJcErWHz+oPxEhRzcj
	L54Rlmp8v54M1eKjUox8TJajZP2/KcW7eBoRve7SjncHXrklPGZ2hrp2Lds7rHqWVq63Zi5s
	M6UP+m3w1bHyAfTxYdrdYXerTfPIHxUkL+HvVxlcQgINZ4P6PZnukmXp9/blbX+8tZuTAoSs
	qaMJnN/AqMVzk0bQBQTHLJgI7vFw9BJLd3CXwhdmbPu0MTBMqhn3b0+tzE8VmOhwaZ03rY+W
	/gKDnI9jHwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUyMcRzA/Z6X3/N03PZzJb/pD7m8bI3DxL4tI3/1zGt/GJvZ6vDkjrsr
	d5Uy7LyOWufyVl2lTCUV5Ux0MyWsi40UiYqiZtd24VLeEp3N9N9n3+/n8/3rK7KqIW6GqDcl
	y2aT1qDGCk6xPurIAuwN1C+y+cKgoLoKw8uSfhZcHRuhNHuQhZxzLQjcrw5hGK7+wcL37iYB
	buamQ16uG0HFxXYMTTcvCPBpIAHuFzbz0FJr4+GWtUeANlcBhjdVv3lodlzhoP99GYYRWwi8
	tUXDuQwPC43tH3jwduVwcLzkOgMPqm8x8KRqSIAzrcUY8g/ZENR1uVn42P5ZgJ/fxq8Nd9kY
	qKzSQf7DN0L0bOlY6y8s5VufcVKdo1uQip0pUubxNkE6+sDLSzfKw6VLdzyM5Kw4iSWn77Qg
	uXN/jqu9kVLWkUEsfe5/zUkf777A0kinFBu8RbF8h2zQp8rmhSviFbrHJ4a4pBp1WqvdxVlR
	Hs1AASIlEfTSeR/nZ47MoQP5X7GfMZlHOzq+s34OInNpZkMZk4EUIktKMS17dOpvEEjW0syi
	a3wGEkUlAdpzO8HvqMg9RLNanvJ+R0mm0ua8vr8+S8Jpx5iH8fssCaGXx0T/OIBEUevwCcbP
	00gYbahtYuxI6ZhQOybUjv91MWIrUJDelGrU6g1LNZbdunSTPk2zPdHoROOvUHZgNPs2+tIW
	04iIiNRTlNFzAvUqXptqSTc2Iiqy6iDl6DaiVyl3aNP3yebEOHOKQbY0ohCRU09Xrt4sx6vI
	Tm2yvFuWk2Tzvy0jBsywIoh8PCu7r33lJOP+me988+XOmXdWtSWpKkOPJlf+3hq7+kxOVuzB
	4MSx/r1OY4GdjG0qMlkLT9fuCb2Ky3fFLNdEeus9l5cUrnvOeJbxk3FfqLtELFwIS0JLNxTZ
	Z6V6B1sP19dwrqma3jVhujiDffHrh3e5DcvI2eoI6tOl9Kg5i067OJw1W7R/AOplAnwGAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1EE4C1C0005
X-Stat-Signature: tyfi3wawmx665484sqgc88kj9rtyp5ee
X-HE-Tag: 1762913546-323867
X-HE-Meta: U2FsdGVkX19PcsN+ueSr54N2YIKSMMMchrouJwGSSe/32N28ktaJHzWbJ2mqUCQV7k0pzOFR1/hH4Z2vON9m6EZnu48d8wpDSLXbYZyzeLpiMlU1dk2U+rRWiogZqElea0Ke7/Y0TBtO2xezaJWeNxAJT5iw4RmYaJnOY72+Mz56Pqr4wEbEwMb7WX8V6jAZbXOZk6J8lHOO8bKFYrUDXDNEX+ykCa9jsVR9J7NTAHIz93KzlY4q0bPBuwK+S0O3MlumNdCUf0Y27r212w8Y2H6wi9iz+t052OIdYKe8ghaFitFShWimQWd1rs50fZn6IGvuVnia6HbV94FvcbCxYpJWgZd7Q782vtXwo/Mk1jxm/WdfJsiHBesuX9Pi/45ZXL6ZTC0B7JwfD8qkFOc1nzTnEdBBYhM+v5bwLJvLH/bc8XWJk6sOdQz2Iha/l1y1mdLIKgeFPSPPzRQfobdfy4Zqrk12P1OTQGJ5zYTbpt114EDQq6ZzBpYxehp0/URCRShYNu29LS3d35sz7fz7zpgfOSjcFO2u5ZNy9ihwEZ9F4qik0uvZhgQ5tCKabyIFuH0ggWX2TtDmuvwvFtxOy4tTkvEFvEUqqJRR7/DiV0NUfbMPp3HV6Shseih8p12H4uhQ9dkkKiS+WlVgdZTnQ4ZNeIeIbP+uhylhZXXudxXyXyr+bMcl71cUaRbMdIqk6Ryq754qxgEXLjAvQSQnUAEBO0rUhRT2QUW0g7lLJbiLeov7sXdARou9nMIp3to2C/Ojfn+NaOZDMRYAsGUDSrPeEy0XbwLfglgYYcMJsG81aqCx+jD8ANY2u3BW+ZWbX0DuZvtQzJnSJdr1kb/VMxtD4PTWiwmJbcK7j1pW2wAEnAozfqFwliyBIb5DXvryf1uWY+zOQIaPlM3ShRajIEL/L3D+bh4hTNTTPMX53zUsiYlacbXoTrH7chy7YwQI8n2LE/LRVMUb9LEA/rd
 IOrOHhXv
 X1gbNm+OFiRJfrP4yWDCGw64keQZKARhWYNgh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 11:57:54AM +0530, Garg, Shivank wrote:
> On 10/20/2025 1:58 PM, Byungchul Park wrote:
> > Thanks for the great work.
> >
> > By the way, is it okay to use work queue?  When the system is idle, this
> > patch will improve the migration performance, but when there are a lot
> > of other runnable tasks in the system, it might be worse than the
> > current one.  That's gonna be even worse if there are some other tasks
> > that wait for the migration to end.  It's worth noting that
> > padata_do_multithreaded() also uses work queue internally.
> >
> > I think, at worst, the performance should be same as is.  Or am I
> > missing something?
> >
> >       Byungchul
> 
> Hi Byungchul,
> 
> This was addressed by Zi in the mail:
> https://lore.kernel.org/linux-mm/61F6152C-A91E-453B-9521-34B7497AE532@nvidia.com
> 
> So, there are some specific use cases that can benefit significantly when CPU cores are idle

Sure.  I think so.  I meant the mechanism using multi-threads would
better be performed for faster migration when a system is idle, but it'd
better avoid the aggressiveness when the system is busy.

Or we might observe a performance degradation due to this work.

	Byungchul

> while GPUs or accelerators handle most of the workload.
> In such scenarios, migrating pages to and from device memory (GPU or AI accelerator) quickly
> is critical and ensure hot data is always available for accelerators.
> 
> Thanks,
> Shivank
> 
> >
> >> +                               per_cpu_item_idx = 0;
> >> +                               cpu++;
> >> +                       }
> >> +               }
> >> +               if (item_idx != nr_items)
> >> +                       pr_warn("%s: only %d out of %d pages are transferred\n",
> >> +                               __func__, item_idx - 1, nr_items);
> >> +       }
> >> +
> >> +       /* Wait until it finishes  */
> >> +       for (i = 0; i < total_mt_num; ++i) {
> >> +               flush_work((struct work_struct *)work_items[i]);
> >> +               /* retry if any copy fails */
> >> +               if (work_items[i]->ret)
> >> +                       err = -EAGAIN;
> >> +       }
> >> +
> >> +free_work_items:
> >> +       for (cpu = 0; cpu < total_mt_num; ++cpu)
> >> +               kfree(work_items[cpu]);
> >> +
> >> +       return err;
> >> +}
> >> +
> >> +static struct kobject *mt_kobj_ref;
> >> +static struct kobj_attribute mt_offloading_attribute = __ATTR(offloading, 0664,
> >> +               mt_offloading_show, mt_offloading_set);
> >> +static struct kobj_attribute mt_threads_attribute = __ATTR(threads, 0664,
> >> +               mt_threads_show, mt_threads_set);
> >> +
> >> +static int __init cpu_mt_module_init(void)
> >> +{
> >> +       int ret = 0;
> >> +
> >> +       mt_kobj_ref = kobject_create_and_add("cpu_mt", kernel_kobj);
> >> +       if (!mt_kobj_ref)
> >> +               return -ENOMEM;
> >> +
> >> +       ret = sysfs_create_file(mt_kobj_ref, &mt_offloading_attribute.attr);
> >> +       if (ret)
> >> +               goto out_offloading;
> >> +
> >> +       ret = sysfs_create_file(mt_kobj_ref, &mt_threads_attribute.attr);
> >> +       if (ret)
> >> +               goto out_threads;
> >> +
> >> +       is_dispatching = 0;
> >> +
> >> +       return 0;
> >> +
> >> +out_threads:
> >> +       sysfs_remove_file(mt_kobj_ref, &mt_offloading_attribute.attr);
> >> +out_offloading:
> >> +       kobject_put(mt_kobj_ref);
> >> +       return ret;
> >> +}
> >> +
> >> +static void __exit cpu_mt_module_exit(void)
> >> +{
> >> +       /* Stop the MT offloading to unload the module */
> >> +       mutex_lock(&migratecfg_mutex);
> >> +       if (is_dispatching == 1) {
> >> +               stop_offloading();
> >> +               is_dispatching = 0;
> >> +       }
> >> +       mutex_unlock(&migratecfg_mutex);
> >> +
> >> +       sysfs_remove_file(mt_kobj_ref, &mt_threads_attribute.attr);
> >> +       sysfs_remove_file(mt_kobj_ref, &mt_offloading_attribute.attr);
> >> +       kobject_put(mt_kobj_ref);
> >> +}
> >> +
> >> +module_init(cpu_mt_module_init);
> >> +module_exit(cpu_mt_module_exit);
> >> +
> >> +MODULE_LICENSE("GPL");
> >> +MODULE_AUTHOR("Zi Yan");
> >> +MODULE_DESCRIPTION("CPU_MT_COPY"); /* CPU Multithreaded Batch Migrator */
> >> --
> >> 2.43.0

