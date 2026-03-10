Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D679FD4F29
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510186B0088; Tue, 10 Mar 2026 15:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C72F6B0089; Tue, 10 Mar 2026 15:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC6F6B008A; Tue, 10 Mar 2026 15:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18F636B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:18:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAA32B7C79
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:18:57 +0000 (UTC)
X-FDA: 84531115914.27.1D74BE2
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 701BF40007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:18:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=r3z3745n;
	spf=pass (imf01.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.52 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773170335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8MlcjDsiq5JTSnHTImtKZk7lmn+XNkfMV0tvdP/3sM=;
	b=8E4zLRRyDmGehOw/EjtLa4Jber+sFKNYemzXzGAPvo6BcyaZKkIPa8yT47YPyti48k9QrE
	/Gh1FaQsIJxl7rzNOEA9h1M0/FJVDYWHRVwdSACzdatjHckhjPkhGE0yW/aI750P9nGgb0
	k9be0ffNlA+6Qr4JNP094UDurI7ggnw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773170335; a=rsa-sha256;
	cv=none;
	b=djkKkWTeB3EyJWXuQkFjBM7aCEs1WMcuVT1cWcivwSFTEtMqv8J+zjJ1Rh91nzd/ENZzFH
	2p4wRiDI3ROVffCFqpPjPpyNF11sbEBXmc+HRpvq3/TGEMcpo+CgtHXz7gkCuo/foL7WNv
	xAhOR+H1jdeeD6Ht/UvBOuZdHfyDSQM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=r3z3745n;
	spf=pass (imf01.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.52 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 060D5280072;
	Tue, 10 Mar 2026 19:18:51 +0000 (UTC)
Received: from [192.168.100.159] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 0B65113C2B0;
	Tue, 10 Mar 2026 12:18:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 0B65113C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773170330;
	bh=SHQ8lO4VCs9n2oeVcb8+8rYSkeJ/w60bsT/WDV4zuJo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r3z3745nKZVE7c2PZ8ynMQKvuykwgppEWZ0n3htjsDaXEePLMXoiEbIJqp9XkYTpV
	 3N/bB12d8KT3NwDyst2nZwmxNNi1Vr04PPxR89OTNHkdq3EoQm85T/XMgly/aWJfLw
	 94f4WRnlkAyp4Xzvh3me4Q79FmhQFpHRN3S1aiSQ=
Message-ID: <729164a1-9dd4-c9a4-f092-d93d775257e0@candelatech.com>
Date: Tue, 10 Mar 2026 12:18:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
Content-Language: en-US
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless <linux-wireless@vger.kernel.org>,
 Miriam Rachel <miriam.rachel.korenblit@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
 <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
 <aadKDCKGHk1Ua-7_@slm.duckdns.org>
 <3303d57a4ea6776dbc66ca72441023f76e6f1234.camel@sipsolutions.net>
 <35a7ebcf-862f-0b3a-a245-c32196a58692@candelatech.com>
 <aadYoaA_JYduCx_S@slm.duckdns.org>
 <de003dc3-3e37-f238-4250-2df16eeb77d6@candelatech.com>
 <68c1ca1381d1871fff72b211890a64eb@kernel.org>
 <bba74cab-7305-a052-7e1c-7a7736ba4531@candelatech.com>
 <5b9b93df8774810a43fceb359906604b@kernel.org>
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <5b9b93df8774810a43fceb359906604b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1773170333-4JhH_YF9W8Im
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1773170333;4JhH_YF9W8Im;<greearb@candelatech.com>;e39a4ef213bcaa75c219f509376588df
X-PPE-TRUSTED: V=1;DIR=OUT;
X-Rspam-User: 
X-Stat-Signature: funju3nex1szo1ni51ux5r8umwdywn98
X-Rspamd-Queue-Id: 701BF40007
X-Rspamd-Server: rspam03
X-HE-Tag: 1773170335-822978
X-HE-Meta: U2FsdGVkX18/101ggzrVvgqOfDcFCfdDI46cNMueR3cPhoQATVQ1TuNFIVq20X8MdM81h1YbnO/hqoMcqnyAKA/Ozf2V6BzvhpiZ2XyVkHmSA0m7lJAgLQXwGgTN+HRmpe0mxov65GTIKvIKyIu6/1hhBJsPmkVXL8/Kq2CO/qu1YizS232rHCoVt7v8ag7hqF+jF9OWdBwz1Gq609wlr63dRKXm51NbKX53moEttfLgHQMBXMSwtEGC6Tsnull8G4KeoXbV+nPgzO2+CJCzCKxToDdvcYIXXI1euQkOzhDBTmU39O5AEVm7QO6vawZs9Dshj6hkyfRgyLeeyqIfXYFgkU8dn5uh/wNhyYtpbhEL2by4v9yNT0IQyHbZVVSQYZFH68kkgwn/VMyiNthDsbYdBgOOUxEyPX1cu4R0TEo3RoAM4n0Mu/fub1BK90C9BjwIPUoYUNck0cd8ByreRZokRp49mSXr6nJ4Di3/dzNKxIWACm/zmi3SlW73CvD+H+mfP39eVxB7rQagNMW6Z0tJJnm99RQSE6RzzLNUxandnEwhGQSJt+mN7DNJOc9H5Ynnroj9LYTpg9Dg2IPJ2PtXFFvrt/ppPgDCfHjatlKAJCJeyj5TjiHciz40xoGkOUS3sha4tf8eEYzITk/NN3yBtsX3OWAi0icKp6bR8y+/tMM1+LYaTY1ljF02gHfSWVW6ZdoLDVOHhBPlqv/FfNfAwMSdQOQaUt17uAmFc6BxIHB9WVWjBKDCxCqAW03GaxqbvsVqu+6LQLnlo0rDEeOtgyJjMMCHGLR9I9ttZPuK5dHnyWxyM1VuP4Qyh3FrdCOS8oKbxfz/p6kBzI7j1MX+2VRdchrsZDP5wlszEvPIZNyiUy8gN9ADBo++xr9Isz7D5ja4BR8JvrErRzoDGKr5BqH+flQ4aDy+vZiokvzp9UAb/WtOuFxpui5fA1M99frkNeQ9667nf9weBsV
 gGhRzJ5p
 VmkeMRwpFvU75vwx8wHA+CJ8pl8zhDVOznQx9/gWpSAZqtZP9+cdD+9qsLSbnldEZlhtw8ZspUzY/KhdiRhQxUfRorNYFgu4WWz/6JiROUU8iUj03ZVq25n5d/y+R6uT0dtF8rHrzVHxpmEpdkecyh8am+zSAXupLtuiNZXoL1yhdJVrxmeiK9gagPaRJ982KfvzQn34ZO6Y9iExJ8LGk3/Q9UwnNAmB0uyJ+t3eBRTJSaMpvEEWBDj4/BmegD7YlzW3NqaQX9LZA27L6+RIZ2ItWo8pn23R7qZ0XpjM4/EUN0aKflj9XXgLnwjIph+Cmmm1r5SdG37KXSsQCLUxlwUzFix3K2XCZe5aPTQq1FiLE0EPcPiZ+5Ug6iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 11:06, Tejun Heo wrote:
> Hello,
> 
> Thanks for the detailed dump. One thing that doesn't look right is the
> number of pending work items on pool 22 (CPU 5). The pool reports 2 idle
> workers, yet there are 7+ work items sitting in the pending list across
> multiple workqueues. If the pool were making forward progress, those items
> would have been picked up by the idle workers. So, the pool itself seems to
> be stuck for some reason, and the cfg80211 mutex stall may be a consequence
> rather than the cause.
> 
> Let's try using drgn on the crash dump. I'm attaching a prompt that you can
> feed to Claude (or any LLM with tool access to drgn). It contains workqueue
> internals documentation, drgn code snippets, and a systematic investigation
> procedure. The idea is:
> 
> 1. Generate the crash dump when the deadlock is happening:
> 
>       echo c > /proc/sysrq-trigger
> 
> 2. After the crash kernel boots, create the dump file:
> 
>       makedumpfile -c -d 31 /proc/vmcore /tmp/vmcore.dmp
> 
> 3. Feed the attached prompt to Claude with drgn access to the dump. It
>     should produce a Markdown report with its findings that you can post
>     back here.
> 
> This is a bit experimental, so let's see whether it works. Either way, the
> report should at least give us concrete data points to work with.
> 
> Thanks.

Thanks for that.  It will probably be a few days before I flip back to debugging
that lockup as I'm trying to get something ready for our internal release (using
kthread work-around).

While working on another bug, I found evidence (but not proof yet), that this code below
can be called multiple times for the same object.  The bug I'm tracking is that this
may be the cause of list corruption (my debugging logs and work-arounds are in the method below).

But could this work-item (re)initialization also explain work-queue system going
weird?  Just using kthreads, which 'fixes' the problem for me,
really shouldn't make a difference to the code below, so probably
it is not related?


void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
			 int link_id,
			 struct ieee80211_link_data *link,
			 struct ieee80211_bss_conf *link_conf)
{
	struct ieee80211_local *local = sdata->local;
	bool deflink = link_id < 0;

	lockdep_assert_wiphy(local->hw.wiphy);

	if (link_id < 0)
		link_id = 0;

	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
		struct ieee80211_sub_if_data *ap_bss;
		struct ieee80211_bss_conf *ap_bss_conf;

		ap_bss = container_of(sdata->bss,
				      struct ieee80211_sub_if_data, u.ap);
		ap_bss_conf = sdata_dereference(ap_bss->vif.link_conf[link_id],
						ap_bss);
		memcpy(link_conf, ap_bss_conf, sizeof(*link_conf));
	}

	link->sdata = sdata;
	link->link_id = link_id;
	link->conf = link_conf;
	link_conf->link_id = link_id;
	link_conf->vif = &sdata->vif;
	link->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
	link->user_power_level = sdata->local->user_power_level;
	link_conf->txpower = INT_MIN;

	wiphy_work_init(&link->csa.finalize_work,
			ieee80211_csa_finalize_work);
	wiphy_work_init(&link->color_change_finalize_work,
			ieee80211_color_change_finalize_work);
	wiphy_delayed_work_init(&link->color_collision_detect_work,
				ieee80211_color_collision_detection_work);
	/* I see some sort of list corruption where links don't get removed from chanctx
	 * lists.  I think if we are in a list while here, that could cause it.  deflink
	 * appears to have chance of doing that.  So, remove from list first if
	 * it is indeed in one.
	 */
	if (WARN_ON_ONCE((link->assigned_chanctx_list.next != LIST_POISON1)
			 && (link->assigned_chanctx_list.next != link->assigned_chanctx_list.prev)
			 && (link->assigned_chanctx_list.next))) {
		sdata_err(sdata, "link-init: %d called while already in an assigned-chan-ctx list, clearing.\n",
			  link_id);
		list_del(&link->assigned_chanctx_list);
	}
	if (WARN_ON_ONCE((link->reserved_chanctx_list.next != LIST_POISON1)
			 && (link->reserved_chanctx_list.next != link->reserved_chanctx_list.prev)
			 && (link->reserved_chanctx_list.next))) {
		sdata_err(sdata, "link-init: %d called while already in a reserved-chan-ctx list, clearing.\n",
			  link_id);
		list_del(&link->reserved_chanctx_list);
	}

	INIT_LIST_HEAD(&link->assigned_chanctx_list);
	INIT_LIST_HEAD(&link->reserved_chanctx_list);
	wiphy_delayed_work_init(&link->dfs_cac_timer_work,
				ieee80211_dfs_cac_timer_work);

	if (!deflink) {
		switch (sdata->vif.type) {
		case NL80211_IFTYPE_AP:
		case NL80211_IFTYPE_AP_VLAN:
			ether_addr_copy(link_conf->addr,
					sdata->wdev.links[link_id].addr);
			link_conf->bssid = link_conf->addr;
			WARN_ON(!(sdata->wdev.valid_links & BIT(link_id)));
			break;
		case NL80211_IFTYPE_STATION:
			/* station sets the bssid in ieee80211_mgd_setup_link */
			break;
		default:
			WARN_ON(1);
		}

		ieee80211_link_debugfs_add(link);
	}

	rcu_assign_pointer(sdata->vif.link_conf[link_id], link_conf);
	rcu_assign_pointer(sdata->link[link_id], link);
}


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com



