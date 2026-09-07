Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3188FC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 149046B008A; Mon,  7 Sep 2026 17:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120F26B008C; Mon,  7 Sep 2026 17:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036E96B0099; Mon,  7 Sep 2026 17:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C781E6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:05:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6906A4482
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:05:22 +0000 (UTC)
X-FDA: 85188196884.08.58AA767
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id DABBC140008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:05:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NoUiDhPX;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788815120;
	b=V1293Ep4EyFwyyoPGPp7fU0tONRtDi9uanh6eQhSxadJqZ8Ed/53rSYU6kjZ6ljmt5pTFs
	IBrsMHl6e15jPvz0Wxfj4Iu+zrspDo7rb6uFjbGJKOT1jH9iCu6inkrgpbUwndQ7HXjVCh
	16X+CPkySNuFRmggKnXaBfJ9fhMCvoQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NoUiDhPX;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788815120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jr5pTyJqXfvpszR/f6xdIiW4q3ltvvAQPTAcZR/VHKM=;
	b=JrAra8lul0TbPALqo724LzjTMP5UmhQ4c3sY20kS3bUaQXgW4Ua6EwPNDZ+fC8SaC2TGfe
	GtqJqHEQuYFHf9EuiQMdNpQO8ylAmUtWXgj1883oqt6H3VqBw1gzYbayIe7h7JW9EOOhqe
	nCZiZ4pxLiTpTTISfgo06jigmp9gqHk=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92f0b5ed131so475415485a.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 14:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788815120; x=1789419920; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jr5pTyJqXfvpszR/f6xdIiW4q3ltvvAQPTAcZR/VHKM=;
        b=NoUiDhPXnUDSOk+eQCGw4rqoSYOwsqDKjO+eVa+W3BFM/FH5m+g/6dZ94q/ZOoJGYX
         sjGDiavE4nctNPMq+iWoQqoQYFlvmRMbLn6Ry1fD7uLkBOiDeiL+bTA8HfMGoOOmlHB4
         OhcSg6TS1/jqretkAN8epDxWXVwqIcRMGtflNNaN1Vgvw3vRzOBYItf3LYX3Ule9/I2H
         ALG9GE+U6/nR9qgElMrc4dyP5SdWPHyNKQYiLA3hT1PEUAo4vXEWiiacpIunGbK0sfLd
         WIVOurPKHJtSi29DkyARwr0Aunz8+uAuZ7ViqH8fum6SFLugw6YHunYYVTb3VNr+Kawi
         I6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788815120; x=1789419920;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jr5pTyJqXfvpszR/f6xdIiW4q3ltvvAQPTAcZR/VHKM=;
        b=NBba/EA0sMrTpoYzpgZce3v8Q2RQ0ufoUq2O7dHf8PziOnk6X3aEBP4BJB089nio2T
         FlzWrGuVoVkQVqWuH10JEVDW1N0fTKN4jUDk6oAz873g0liNtlB56J2c6KeC3ifEt6eK
         H0gxebB5jdSJw+hL/ETPe2+XFQDBxXD/Lg+bbbdWt18mdAfDwHTUsyoFB4Y6ANvqsoQJ
         JNCQ8qK144bTsIC7AGT07gFJFEt3yMALIHA0k29TcCOLSxDAEUNs+5FTs3ufVvnRdDFg
         zyPD4NKwYrTln5osQuoJN7yzAWQPR5mJwURFHxUO0V4DUDbtOQ7km0vk8TNkzW5DYXSq
         L/uA==
X-Forwarded-Encrypted: i=1; AKwUvByd1RqATa5EsmoTldqalXokE2qdZbEd9vvdyASvuOsbjRWLbx74DGqN7kATZ3oco/qyTbuUSDCIjw==@kvack.org
X-Gm-Message-State: AFuF++nfBvTmEnRCTQuu4TH1CERByEGrLrPO8UcUtZj7YC72l92GUssz
	gu99EV4CN7UCkV00Q63ql7UkS1+kBmcCK0arWVLcRK0K8CSTthL3AxYxaMjc0gxfbvk=
X-Gm-Gg: AYBFou3lbRgBqfD0smWlelTc8WyxbAdD29GJ+cHeqXWAVy5ncsSUQt4nP5G+JcGNNxS
	S7NYIBoPfHD/rPPA6rPtsOL3OqCtF2Gda2B8PeLMRId53ds14wpAcHWytQnlX4uVnNfY1HBbw8y
	jdovOaIL1PutQH70BctOHm4a87jmuJTX97sMGqtNN9NIttzdcsKzisDg3dLE7GuQuovNLWmDfTZ
	5skhITlSpMCYY5YbEfs+OpiJIOA/KRXdZbrvxc2SUZwoAMUJuDWRNSXeWqCVadkcoRJjwQzeVBV
	bRqV++9uuY1kqozWcyUm3QO0vF8eY+Y7u3WuoFeU/nwhOtcS4hUVVOywKHGjgrgjs0kLvWKOp3v
	cxq3JtwLWt8zefoJAfOhBSIwjt/2oW5lm7XY5Eu1bxAYvNywk47sBAUmtDtZ2zVYe53zyQqnhxt
	HRWkKMEYpxNZJ4H9YCHUBlcERL8Aiw9AbLg830ohlhiGmHovafxguIDsypCoZ4HW/ZGEn5We2fq
	Fc+bnD6+hIMz4HctYcvW6WXg+mPcpvAOMyT8fP8ZKASyjqHBIJaEfE=
X-Received: by 2002:a05:620a:404c:b0:939:df5:977c with SMTP id af79cd13be357-93980361c84mr2678122285a.19.1788815119859;
        Mon, 07 Sep 2026 14:05:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9399429b97esm677101585a.29.2026.09.07.14.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 14:05:19 -0700 (PDT)
Date: Mon, 7 Sep 2026 17:05:15 -0400
From: Gregory Price <gourry@gourry.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ye Liu <ye.liu@linux.dev>, Thomas Gleixner <tglx@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>, 
	Michal Hocko <mhocko@suse.com>, mic@digikod.net, david@kernel.org, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, gnoack3000@gmail.com, ljs@kernel.org, sj@kernel.org, 
	rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap8mgnpE7D4TTrno@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
 <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
 <ap76-0-hN6CAcYXX@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap76-0-hN6CAcYXX@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DABBC140008
X-Stat-Signature: ewfbzp6hcaoaf9iprjb7a4gu5u5jadgi
X-HE-Tag: 1788815120-913348
X-HE-Meta: U2FsdGVkX18Mnxcplf0nBUa3Xv1Jq4g8mZLpIq6wtka8C6aE/Ubn0cJspWoFtG4UhvgoMjI8eMuLxqZ1sHJYTpfBvrG5mYp2YzjpK3EiHTcEHKgPoMiFquwCofMX9QD7Zb0XPiGsHPxPPqevcYW7ZCa/jXiUUb/OFc1ePSmNTQPHqBg4ESkJeQZyIXdYeStgWkIcyyxWPluPsj8eCL0I6vknoto6Vw31aYTv0BrbBDECb/LMvw2K6BWH1NzX2xbQebZBhrd8PY/lM6IdTrA0olUk/obN7O/Aum9K5twrRrJoPEFRiv+Wc6kP7gWYaB17y7jvYbAt54TPWX9fVlfw4esRcz0A33A1atnRiifOJgWKxKoUIDEbOhXgHokS9G88aiG5HLWRXhKcXKucNhxgpeyqe5OxgmmOG7tLv0istl+oCtoJ+rQU9V49mW/qDL78A3ltyOsqTldQvq3Wt4AZn0O3mubLv4ucngLfb2NTaamQwfBO5Vb/b/7VbNLmER23J72KujW/6OlLh2dT6bsKdRBYUBaGhwd+hwc/Dy87RQWhgCsAvWIMbAmFQufgWOc3dYEHM4a2RboAtccah/83OTx4bRSiP+JC1p5So3tYQrs+1Cypz99uoYQPY8lciaq6vrWp9ekl4QRGKQbn/s+zzw7xIuy5OFAr/QUt590j9gYYXYwocXC8GWuB9OoRdoLU8awPIi0EVD2yRtphM9ai4RTKHeDspoG+jOBHFlH5+KyJw4grtY3NOwZ5cyn9lIvRigwtcNRYg4dC9ujcAi0MW2G+jkJGunTBoqk8yKuJZmIoJEMUOxrmxpXG37+KKOaq8NqlkpJKoq9MYhuj3VG5+zDPESJnSGA45vsPoowM3SzM6QLn09txAy8u/tABfgzO5GRPp9Sg3Rafs4EANrYX4cutRaklx5x/1WpTnRGP0pTe67Fz6/wFFVh4SBelMGw0/6atGY7baOaaY4n3gks
 iMRVdeRS
 cAhkC2Sxwqc+TIWZ84FQxf4So8S2wqjkcLw0NiRs9FzxZFdlWCz5m3/TLwliRFna2x14HmItC9a3/MkYYsf5ZU4jMgPCOFDf0JXAAH8vbHN7tncMmQswOOa64aI3lRjU2Mse3N/vknPNRB3gCDqlnnZlLtToqk3MxEY/5yKSAKsnY7Soiw87z8FlBYBC6qwIfQEl8j8WBgiQfsS/xeEOTrJFQLmbbOd6uI1nhTjIQgMfWycFSbVfj+yEREMU4rD+lfoZHS8QcwGZbYJKeAY9arJG6nD4pkVc+g8YyJ6y+kVGSSJivm6NnsrHpttYCUkrt9DD9/oHQlpgT4iNqAHREGXyZNadjKo4PvbIrRH9Gn+82zflcW08Cp9/5UTLv7vHcYV05FavBJkVfU1Osrog8WLlMN59C4MaW+6DeqYz8ghKnKodVVOAWvOTwOrahArlYPSbQ83ABi7jVyvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:57:15PM +0200, Oleg Nesterov wrote:
> On 09/07, Gregory Price wrote:
> >
> > On Mon, Sep 07, 2026 at 04:13:31PM +0800, Ye Liu wrote:
> > > --- a/kernel/hung_task.c
> > > +++ b/kernel/hung_task.c
> > > @@ -315,13 +315,12 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
> > >  		return;
> > >
> > >  	this_round_count = 0;
> > > -	rcu_read_lock();
> > > -	for_each_process_thread(g, t) {
> > > +	for_each_process_thread_rculock(g, t) {
> > >  		if (!max_count--)
> > > -			goto unlock;
> > > +			goto out;
> > ... snip ...
> > > - unlock:
> > > -	rcu_read_unlock();
> > > -
> > > +out:
> > >  	if (!this_round_count)
> > >  		return;
> > >
> >
> > The sunken rcu_read_lock()/unlock() + scoped_guard usage makes this goto
> > at a minimum very confusing, if not actually broken.
> 
> I am afraid I misunderstood you concerns...
>

This might be my - admittedly shallow - understanding of scoped_guard,
but does scoped guard handle goto correctly?

On the surface it looks like it would skip the unlock entirely.

That is what i mean by "at a minimum very confusing, if not broken"
and why it's generally discouraged to mix cleanup.h and goto.

~Gregory

