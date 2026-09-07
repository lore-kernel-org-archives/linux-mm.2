Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32656C79F9F
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3201A6B0092; Mon,  7 Sep 2026 13:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D10D6B0093; Mon,  7 Sep 2026 13:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A676B0095; Mon,  7 Sep 2026 13:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5CC36B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:57:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 753C24027E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:57:49 +0000 (UTC)
X-FDA: 85187724258.25.7C354DC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0E5E7100009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:57:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OqMoUN4F;
	spf=pass (imf05.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788803867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PBB+Ha5hfEwnTM3XMtEUMJZL5woFR7RP7WxRg6VNgHk=;
	b=Ix+YAY2g3o5ucSIUxCDAGjl5kHnt0U+AtYXvUSEL1baOU5HziQwQBo5/eSfA3RjKM1wpPg
	/uhdEWEVMHNEDnXx2bai8iZafpobNIhDq4VsT9IO7Bl9XlLWBaA4SF8AljlJS6dm8II03K
	ktbQi3y8/laD0v4fTo8WXDTRNdD1J2g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OqMoUN4F;
	spf=pass (imf05.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788803867;
	b=aeSo28+ULsvWVI9bpWx5NxPY4bIPO5dG1X5BqpcQUETOzG08kf3eDLA/rhaw0QafDyADud
	yQdQhcdflayZqge/f8codqQ+yB4XFNZb4wjyu6OpmaZBfAKVOLy9jhrWk+88KPAzgZK+iE
	9Tm0ZWVZjs+r7sVPIR8swjBWETQleEg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788803866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PBB+Ha5hfEwnTM3XMtEUMJZL5woFR7RP7WxRg6VNgHk=;
	b=OqMoUN4FIhvbPYDXtdgDMuc2VEsCOJx1iQcsahSjVa/7Gw8EBzaG/gaKwmjtEglfAM92Im
	usJ3xYhJoGaKHICPKYmOL7J3crYKiP9qOTJnZ7zJZuiBKROmyNVDQOEFP40F7+4lXmw/zG
	I7uLVto1EAREkMiUnCT77mSpqSzL4Gg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450-thBD9S4KP3KtKXMD-0xVlA-1; Mon,
 07 Sep 2026 13:57:41 -0400
X-MC-Unique: thBD9S4KP3KtKXMD-0xVlA-1
X-Mimecast-MFC-AGG-ID: thBD9S4KP3KtKXMD-0xVlA_1788803856
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ECA9D195607A;
	Mon,  7 Sep 2026 17:57:32 +0000 (UTC)
Received: from fedora (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 779F3180059E;
	Mon,  7 Sep 2026 17:57:16 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon,  7 Sep 2026 19:57:32 +0200 (CEST)
Date: Mon, 7 Sep 2026 19:57:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: Ye Liu <ye.liu@linux.dev>, Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>, mic@digikod.net, david@kernel.org,
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, gnoack3000@gmail.com,
	ljs@kernel.org, sj@kernel.org, rientjes@google.com,
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, tony.luck@intel.com,
	reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com,
	jmorris@namei.org, serge@hallyn.com, pavel@kernel.org,
	lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
	babu.moger@amd.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap76-0-hN6CAcYXX@redhat.com>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
 <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2ktPKm0bnK3bikdY2q_piwHeF8jaFSAvmsJH0uCSIQo_1788803856
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ghbhkd4sh7j3r8zxky98i1qziosob476
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0E5E7100009
X-Rspam-User: 
X-HE-Tag: 1788803866-576693
X-HE-Meta: U2FsdGVkX1/MMXHyJluO2dBMGL9It0PXHysTJZKnWMsZeTTAUZ2fzjQW63hSXb4aKohr1ySVlrVXsFyhdXzPfBMuBn4Pqw/mwncsbdsq2LOxHgfGI47GggQDSkeTxeYQMaBsMHJF/KSHjvWhyeUhLGxBwt+ybHaDjDl7dL2sGTzlT5jB2wqU3q1aAZQg3A1cOg6ozK6pv63oFeVx6TfCyGoYK3WWJi1BVaFGESi4VNUun/75zA8bwhj+ISs6uf/1uzP/XYFR3dVIdEDGvM/IBoJXGLdw19tOj5kpurRG/pbja9yNWeaKLPE8uQ56eTGtPJAK3Mxkfn0nOWcXtfMpPfAKxYdJxrY3HGTDZI15OIg8xI0F9RihpHOwrGeksvXHfEQntjBnaSb+fLnIv7HwTG0EO0x4f1a/K7OzzSFhmRkxnguL7lEmdrMeLNCG4yuRRrcgdcEs0tCAa/5maScxWiFEyN5cD8Hvwxlv7/rhL5pxFmaTAgpVnn+3bFOqdUN+fYWVzqqxNZOKjlO0r44Xt84Kuz97tgUhAzEruvjK3IR8TqfuDudrU9B2+hDHbQFoxAL00Z32Izyt3pd/XK2oyqXsVmMPTPvimHt9b3lV9sSi0xQLR8+qAIaHMQrudH+B2l5kbw1FHlCp2GAqxYBZYCgGF9uP3OpegX2eRWPNK13HTUsOR4Uwzkfc2yoxX+wwZMIhqJiV8AaFzZGll2k5SwC1zKMrtvGJU2LkbSEFdrkPdGE0j9HsCLoHhKHXRLWgiuvaH4MPPPfEmyWuyDYJ0kgxx+HUeOYJ/PUauJDotm+btM5gU2SRA7ggJddBFUUDIV8NynVOLJxfOS0bAtweF2f5Bu2xSyeScMhV/8IvDhuMP5jHFJag0bNZ7LvUb+U7jlvQOwbpe3Bc1k4lWWVJhIHI8XwrKJzm7HEorGuOI2EtGjOD5I0uxjYARikIvSnTLMOblkgZjlWnYbLZRxn
 0CHWgMyY
 Bamy182xw43wTDpKHpY7dotm0hYdjvX5hLMmwi1+gN/wFQtKxd6KtvGcUtz9rRa71tCea9yCXPKyDMhtk4H+4+LiEZRVb5HZHOXKODj6oeXu+9qmEhwSHER8NV59KDJlgh0A/hgik0RYOcEzQnNycoL74Zrkn/kTzUVqyi1VQ3ihpBAzGr4bYoKqeta0CtjwjQyh4eSCw2tL7KOZPpjUg20Kk+43w0COVzsvIS3BczMov5fl0eyd9X6a0Nn68ViCwGM0prwKqcgyys0UON8et55q1ZbKyK+PrWreOpqPXRUu8g/+D0e/PDqgizqH8sHaINUUdlBydX9465VY8jhfpWr9YrbwKPujXCEIURRsfFixnDRLgUaFrfJMOrewVzly7rphuqjxs8lu4ZBl9JMUKG752vUQqXXQ6o4T3cF5Kk8zkCC0bLL9g+fytZPBr8aX/LZxTd1SR+knthvKDGAqtFa6+LSrRTZ/QpCIZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/07, Gregory Price wrote:
>
> On Mon, Sep 07, 2026 at 04:13:31PM +0800, Ye Liu wrote:
> > --- a/kernel/hung_task.c
> > +++ b/kernel/hung_task.c
> > @@ -315,13 +315,12 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
> >  		return;
> >
> >  	this_round_count = 0;
> > -	rcu_read_lock();
> > -	for_each_process_thread(g, t) {
> > +	for_each_process_thread_rculock(g, t) {
> >  		if (!max_count--)
> > -			goto unlock;
> > +			goto out;
> ... snip ...
> > - unlock:
> > -	rcu_read_unlock();
> > -
> > +out:
> >  	if (!this_round_count)
> >  		return;
> >
>
> The sunken rcu_read_lock()/unlock() + scoped_guard usage makes this goto
> at a minimum very confusing, if not actually broken.

I am afraid I misunderstood you concerns...

This patch renames the "unlock:" label to "out:", and to me this makes sense.

Unfortunately for_each_process_thread() and the new helper can't use "break".

Oleg.


