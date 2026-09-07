Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A795CC79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5EB36B009D; Mon,  7 Sep 2026 11:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F546B009E; Mon,  7 Sep 2026 11:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924CF6B009F; Mon,  7 Sep 2026 11:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BB6F6B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:43:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 167A8160197
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:43:53 +0000 (UTC)
X-FDA: 85187386746.08.4A1F8B4
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id 419541C0005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:43:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QCklm46V;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788795831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87Eb9cn0gqF/vxYu718MPm0f1YFf09SOKLR2T0rK7Rg=;
	b=MWPN262diNt6eUkyAWUuhsuz6qkBWdRSpHJ9cCadn7MyIrCw/e6PEpojURaPZBeLofeL92
	z5Qnj6gzZFMgyJHts7WZ7POrloA9X4XUBMCHgAi2gswUYyk/ffyBfMB/qwlDFcoNuPcWGs
	XLfze2PqaaF6dVaxQgyzTy9NgwlHk8o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788795831;
	b=ffr0n47luH/ZBukKwbJ5XB/IUSgyjhKyb9fSHi2w4tqZChE4KMmv3HcAvGwC3SdSKAdtJh
	kkKGK8xF0EPAHu/fhNU/9KvPKI7dwE7TmCY7jcAR22xsmxqnJhdk+BQctqdaD/1LpdzVyu
	cvm8UMOFr40yuRo8BGu9eHFFzLHXaTA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QCklm46V;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfe528e9so1054486d6.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 08:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788795830; x=1789400630; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=87Eb9cn0gqF/vxYu718MPm0f1YFf09SOKLR2T0rK7Rg=;
        b=QCklm46Vp0qMgyw+nAr4vVfNspvk0fpBc/e1Uaj2W3GVG69zu2YsoguGAut8KdiHge
         3HgT13kQimk1i/Un7Msw2FeO5hPHmZ5DKXRY0pXNQ8lQt4SJ+CI+5IuoD9YuFLXXw0/O
         qxoXWT26TFUluU3bg4PVZxPwMuaVy7S/rbOdzCWdvLStAuk35jEZtLsCj+2XIu15BOWm
         ssY8iefwKHIBel4qZeaYealMc96NdHMhPR92yZu8aUxEmWn+N072Eglxn45+Eq5FxkR4
         gkOkqsjV7cKeQ960ljVTqQGo7Hxz2e0u7+r6f6FL7E/VhyBqwXuIb+toPYRqwJuIQOhK
         J9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788795830; x=1789400630;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87Eb9cn0gqF/vxYu718MPm0f1YFf09SOKLR2T0rK7Rg=;
        b=G0LxVghxoljsnMCCRGcJg+a6yp40oCWz93q/gQqxDDtS4n4LyJ3NVYit+MjbE2Ex7O
         xRCRjq7k3BYjEu5rolNgQQ6Mrt+kdzqLjjrt5csIXckMMZNuXHBRsZ5yUQStS9Erqwiy
         GXdJTQ//MUHcYyMDDyIB5ZNOSCaWV/UUNRiRcE0275Tdls0wdGHuOlWOPRu5q2Ez+qH6
         xuAKWuzwN2tl805K73hCXjZO+X/YdrdnTMz2Fz0I9/xebq9ppjhq3Ek6hm9SY1l0xqGu
         /GyM1xhIyPAMerTijGzfBeZKipDIl9OUveflkOrzRX0K1dp4QnjSF2j+t3l4vXAHMJVE
         G4ew==
X-Forwarded-Encrypted: i=1; AKwUvBw0hzqOSND6Oh8dNXvfcW/5iz3Egt3TOE2k4+jTPCvWn3ieQqXZ0Aee1UkoIaIUP2OJhbZA7/2kUQ==@kvack.org
X-Gm-Message-State: AFuF++nJJmI4bJX+Vm1Tikj/Vq4XEUdBVf6hNmNgzPds1i4P5Z1L+fyy
	Obd2PyVp4SBV/dbJbgUpAyFnwm8LxeljonpnyCOSCG9FPiHu1X64dGd12+ruVvGIrwY=
X-Gm-Gg: AYBFou1YWLTSXXD6JwyN+WO0Klx6EOqs4/E2X4/iV6xb13tjWsiap9NoWPcO7w4Liik
	5gBAZVy6xYTNSsevC4cyyRhS0Rho0oeW59jidkOVan7bwwv013jwYuz03bRBNB/mVMW/L/l1hQ+
	Pl0xkhSdSqmMhpLCV8HWOWdsAgJRSpCee6QsF2mpU4Ji/JEFL8smyFr4f0yiiaWViQQDyP3r8UR
	BnNo20+eOgTtMn4tMQ+aic2aBLDxyltIdYuEQXnbMgFouXBZafDjq8DzJW4He7CnUjNTVVkbqyV
	rdfoBAA6Gb+K5nFlItL5LfSvgT3aEUQqcanlYx8OO7bWM6HUOXVRZZa7+DtKhcnbO3kSCtZtOpf
	/lV+jKc0EmLvZX7SC3RRSEaVGb2HV0WxUh5qa1E1/9xRDtqB6NNhkP3n9TRCd7uTJqlnrXchNzZ
	CF26rRF4WgE/omPlO+GWILOjyLH67CmpGtdFij8mx3KTG6QF96heLGm4RhS/AZMEFmO9Va/UK/0
	6sydwImm5sqaCmWc6JdMAtmc1OVHenLDjw3MvlWy+jlMg==
X-Received: by 2002:a05:6214:2b85:b0:90e:9ddb:1224 with SMTP id 6a1803df08f44-91061f709e8mr21563666d6.4.1788795830418;
        Mon, 07 Sep 2026 08:43:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040646d59sm93755486d6.8.2026.09.07.08.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:43:50 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:43:47 -0400
From: Gregory Price <gourry@gourry.net>
To: Ye Liu <ye.liu@linux.dev>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>, Michal Hocko <mhocko@suse.com>, 
	peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, rostedt@goodmis.org, 
	jpoimboe@kernel.org, mic@digikod.net, oleg@redhat.com, tglx@kernel.org, 
	david@kernel.org, nao.horiguchi@gmail.com, rafael@kernel.org, gnoack3000@gmail.com, 
	ljs@kernel.org, sj@kernel.org, rientjes@google.com, shakeel.butt@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org, 
	frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, 
	josh@joshtriplett.org, urezki@gmail.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 4/8] mm/memory-failure: convert process iterator to
 for_each_process_rculock
Message-ID: <ap7bqPro90Mg270u@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-5-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-5-ye.liu@linux.dev>
X-Stat-Signature: 9qqafodiyug54j7wk6b7uy1e8cdghz4p
X-Rspamd-Queue-Id: 419541C0005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788795831-636492
X-HE-Meta: U2FsdGVkX1+RoupQabWFMKsLPPI3mGPB+3gkHqd1XpCpb9MHogLXo6WfYSYpWTE/GWZWQkMsmGesseyEiLWq58PNMpc3p/xPCab70X7OXmpEBDJzCxY3gDwXz8GvRd/IxNDfgIT2dM9S6HdhMKthUN7kpAs18JFiibesZ6lBoAhUtU3XYDL3oqNme3r7jC8H+uAf4xcmEqN2XMlVwIPxO01GQP/zKsvfii9wMPyyiOzNppmg998ue244hHLYPZXFG8O0cVg8mO5jYMDs4OrgOfFG+aRRZ/8HlMDRtEyIuiSDppgy+keTVvcfZPTWnDExgrNB5Fh7YGVLTHcFwtXdgap5n32htSXtJkOxMvIhiUdvkWztGSFTTG6nebROfb4+UUXsQpkHEkQKfxAgRf7JdWdtj//gkVISq/LNe1LaQ/6ckphTNOBoj53rYItDPy7fSr50+YP7Xk6O+2cXNeYf0w8l8ssXXTXlbVFFRJgOAiUzIcTT/R4os1r+ma1KmEDniPkygViWG9hXUFhNAN6z1+0efI/QZNBhAvC9v/WdurZ7PtwJTNry1SEvMiHG5GS1XzdoETGgKJ/k+AyKRaUVcNf214+WL+sahW4l1hMyjM25INNQo6DfiUc5chuyVBygntcGJS9LHbmn3VE+y+AGcRBXnNcumZdj20RO82JsQ2kWs0DQUFIqcghuUm6MfEzmsqGVlKNVLIIngdpMXeT21CtbQusdluXmz4Jy+jbV0Rp39MVj/d9EaL5frHuH8cjAgqOSj8FTobCwAEWDiAu/M07wZbj+abLEGnRbrJsErgprnOtaGWAzvqWPwIlqCYZp6vbIKFDh7YgcyuVrx/xjgIWurAFsfVds64EbfZu9mJ1/XXl1Hl/V3DVGiwh9yu3L5OSPTw5W9+bFhcFgkYRRMQ2C74MwhmuqAQgXl7kjmond7tk3bA1aKwkP6xwhtOo4TdSO/Uv0rUREpIcNjbW
 ft6SwuFR
 KeHky/VeY+NYmGJjuXu+aSFZG0sa52iJxTjInB4ahp12pamq/pAcAB0ImEYNtNPH1XXlFhSLcG2AjoxwRxVLYoWGUqexe71UnvPk9KlCfny9Xl9pgl7k2ahKpOpVhQrSCc3ameMTG+iUXFCV0fp9ZWtDxWufuewz9u8d4YVBi90/NtbuKCIwm5TO7vvdJCI4zlCxT4ln0/f8nWCFXXtyT2D837dooFTdh1LkX1GCJpTn6ilWGB6HLm4pZAolXLEsGuTGkoAh5TG3Jv91cq7xla25e4PSrz7QlGhT7SdaoXE8HQRgsfq0NMn8f3XM4Ke1QrE5pSZ2smimFYScmbsRUazIGX5fkZxRibTechJZZC8HhGpZc/jyET0kKO4XcSFqpKbASmr6Yk/xgCi9xQ/R1/t5XdGNU1z4zqjRPQAAhRU4bI4FYwESQBfWjaK2Zky83FCJ8KkWFeBOU2ZR01yYa6SUDOhhiTjFo/sI4YTPszbQhjG/H3MbAiGF114VkQH9BwD1AzJMvjhAbAehOrylsW4c2qETusDAoEiopP+HaMoruFUlJ6JreMcW1lVrnE1ukSjJqllGd8714TreTvK93yg7fSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:30PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
> with for_each_process() loop in mm/memory-failure.c with
> for_each_process_rculock(), which scopes the RCU read lock to the
> loop body via scoped_guard(rcu).
> 
> In collect_procs_file(), the page_pgoff() call now falls outside the
> RCU read-side critical section.  This is safe because page_pgoff()
> only reads folio->index and does not traverse any RCU-protected
> structures.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


