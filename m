Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B5CC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E68B6B0092; Mon,  7 Sep 2026 17:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479316B0093; Mon,  7 Sep 2026 17:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3138A6B0095; Mon,  7 Sep 2026 17:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF436B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:40:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93A341202EB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:40:55 +0000 (UTC)
X-FDA: 85188286470.01.6E285A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EE69040004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:40:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UE0pyYIv;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788817254;
	b=sYwOpcWqGGgiGTsXkKdqLKKqLh+3Dd67t9ErVh/bKKCtx6k9AcO535zJO1H13voq6jsuQR
	uOokS7eI4jC6oxmkXsBUmUqwZPp6jmtKSks+vjSi1k938BPyl75y4D+YtJ2N1gB618t+18
	ZG8ihw6Qg3IQHGiMFQqq4d8lJ72jytA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UE0pyYIv;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788817254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+URJUqEKl0fTxo39EvOW6Abd2LXVYYfRY7Esq7fulcM=;
	b=J0Dpvxpn5rZbCgNeCHZchlqYwXzpRuqicWF8qiZ3bMw1PQK3Bmls25YFMMz0SRqbQTt15B
	xhd43J2V2kPyI8HAU8NzzzSh79YdE886G42YvZGOJjT3l5/WT3/MoZuIhDEpp2sTXpYASm
	EMpK9kkqV7ChYb2I6JJRV5Z+ExerlGw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F7A4601DB;
	Mon,  7 Sep 2026 21:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1001F00A3A;
	Mon,  7 Sep 2026 21:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788817253;
	bh=+URJUqEKl0fTxo39EvOW6Abd2LXVYYfRY7Esq7fulcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UE0pyYIvk0vio3jkCrLQyN6+XkN/xYweeR8nniFUl/2qfAC7KVfzk0v27PwfA7nA1
	 jRwk098mQw6qKGClkymTFqzrBU5IwJeY2MbeYz3EJganLj5O47iUGeeiW500wrapHc
	 dGvrG1LnLyPqBFPGV5JWA5xYwsuqcZ2p09vnT/2l5josN6K/hITJMsIfsDvo9Vy27m
	 E59Uj6NHvY09RtjyNlQw4SfjT3QGz8gFcn2Uger6n4ELkfGeTGUUW3jYVOLk7ue351
	 Dq37HIp5KeM6mrFUwmPlTDlmGzF3BQ0XYMidwrsKjXVqywsX8VLqcU33O91DyZm56U
	 7nhA3UnrqSbfQ==
From: SJ Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	x86@kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"David Hildenbrand (arm)" <david@kernel.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	boqun@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 6/8] fs: convert process/thread iterators to for_each_*_rculock
Date: Mon,  7 Sep 2026 14:40:43 -0700
Message-ID: <20260907214044.88682-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907081334.1152889-7-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE69040004
X-Stat-Signature: a6nu6cg46trpohzk4bbam87ra8iqteyb
X-HE-Tag: 1788817253-100697
X-HE-Meta: U2FsdGVkX1/1wPJBSj2ze5ckQrOuTs2jfQaIxcMfZWkd2PEU6JmKsPjDSXTNfNjKYA90NZSu/H5SCrvG4Yw12NcXJHO8y9CDO4m4uTIjtdCi2JQtbpdX+E+LDvDvTefxmC/S771HxF7b77+34k2JZitb1FBsEwX1Jk3vhogD23KXheWDyJ5MZ3F4w2CsPp0F/tCadUgrCAM1dXduDpIvi6JZOEMHTI1YWB3vu9jnUBLEuHXTeaEgjF55REshZNwfzigotlj8XSzk0GUKpFfrTZHeTgIs4uc+eheQrun4Kpwgfw+z1JNy8obAzz9NCPuJxn8x0wsS8jOF0QNSMWoUhUjUxZdP98/RC503rX1+S+dDQwO0wbF/LmyNcd+c5AmoP5OERsDlW3h63yqnPRKTRSrjK+euLqhO220qT9sUt4HC3YCGJunvMeQboNLj/KLkpgXT//GZUzYuWVEPiTfCYlLqep3oW3mDPZzJU1PPQ+8xfPkOs0MIQwuhY6GP877V6O2VuymzN3YG5QNA/M8w6ISW8y6+4OSxNd1wNt+bht3BPTWjws7JEkC0Dg6yJBBVaDIn96B/40UlWcsGz+1zg+DoDjk7OTDcMXJhmJlIl/RdThiYhouaZYm1eDhzGTaQV0kVLn/YyziGLIX2eRAbZayAsOyEoK2L8Ox0BO8rekZcRINT1lLGLg9T1dPmAyR0J3VpZY6o3ntquM+DHeCcXSggKEu4nqIQ9XjvVCCf2cqkxLdcYCXu879pFPDGz2z8vtiSUGm/lJxtN9xAA/sG0WWasqRP3lLVCpOSztgdyG3siRJNVMEfXgobiuHQrjzlFQsB2w40zrx+mNLW2548ZvIu6a3TCiTPo5In+imOvFKG9VVxmBizEOHCACHvSMohR3rkYEebyJnNHWKIB0eK5qprCPVfKfbJn1eHTzQVYQDDWcQGNTiKCpDP3hjBbASH9pGe79soDiZ4FIktW0m
 wqRykkqr
 hkCgmgZaxHA2ukYCKscrtf8Fp9wZIw1UCYNghs15mGwljMbF8fgL5o/zLaBWlfJMmGWWsRSqRSJi0h/tcv5SLRCtJq9VQJIAomqPCDLgSRuR/4Rh52IzLTMQEbjxSvIDQzPth8EhFMagcYw4NruKzanEXVaRHHXa9NX3gH+uHFaqK1eNrYBMcAfU4dvwMC+IbUUBJEBEIkhhM1ALb4KKio9mZXs+ky3ONfjr2+KQCf2Jk1rStohzZFyXVK19duuss734pQZjCJP6bj9zV+pyDoSDxIeNIfE6nctl2CfYfftQ1FulOXs7OBKtj7XxfQNku1ZvpSKzMDBwJgR9CdkiNDIhL5jOtJMtp/FSndqP7Q7FIPH/zVYDFVEXsxnHNk/6JzDHY9GqwIC0CIO/TQkBMtQ73ZlratY69LWf7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 16:13:32 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
> with for_each_process() and for_each_process_thread() loops in fs/
> with the for_each_*_rculock() macros, which scope the RCU read lock
> to the loop body via scoped_guard(rcu).
> 
> No functional change.

Looks good and correct to me.

> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

