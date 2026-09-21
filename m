Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A5A1C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906976B00A6; Mon, 21 Sep 2026 05:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B71B6B00EA; Mon, 21 Sep 2026 05:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD126B00EB; Mon, 21 Sep 2026 05:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F98F6B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:23:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B92DC160590
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:22:59 +0000 (UTC)
X-FDA: 85237230078.18.61CA7D8
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	by imf30.hostedemail.com (Postfix) with ESMTP id D00B880002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:22:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WTUC2a2V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982578;
	b=7nR1PUpB1XY/4jX7RXCkBoUBhUYhM3vIrIukmb7Cpx9+rHpQrRVkSWCYB6H/ykHB6ial0p
	kubB2PI7ek0qQlvCZH5Qf+XQYmEJ9yStzGviSzAAt6ZPLZDzzhP8c9C86w5WCqIqQ8JioB
	NpsJMBMSHaqFDRLz3ZPY5Ga9rx2xiqE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WTUC2a2V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aREBiETLQxDfNXXaajMGMFX5jHis9OMlxYEXJB/Xli0=;
	b=UBRJwTFmbZqBbgc0pSFFV5qhZanni0HYl4NSot/L+RSYmM5RbTGhOdAdI8fKVt0XYbOq09
	Xcw1pAlofJJqBlnMqGF7B0kezgbLsAJyluUV8Gdbk6817acLSofp9bGKOOwXMRwLRr6Hq9
	b/utijdzA/ETuOxLLZV3ojuKwbPsQO0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+apiCWXB2L/Ctun6eWEUkwbOkaFG907R5s++lFpj7MQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982576; v=1; x=1790587376;
 b=WTUC2a2VzrlQ2BMfoVUjs85qxry4/YDC6KfWMIl/amxO7xxZPqyBhOw1LIUWCxQeW2PK43I5
 RzpLMOhMh37dI09MpeG65XP2bED7/NdLdCVzWVbz0zc/qiZR41Gk6mFPIsk00QMbzrxrtj2wxAk
 +G6rWuh6+lNFCSeR9dF3xtmg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0629d28ba88758c8;
	Mon, 21 Sep 2026 09:22:56 +0000
X-Mizu-Trace-ID: 0629d28ba88758c8
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	gnoack3000@gmail.com,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
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
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
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
	babu.moger@amd.com
Subject: [PATCH v4 06/15] freezer: convert thread iterator to for_each_thread_rculock
Date: Mon, 21 Sep 2026 17:20:52 +0800
Message-Id: <20260921092101.89285-7-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D00B880002
X-Stat-Signature: awr4iysy98na4k4kcaz713xqx556fq8o
X-HE-Tag: 1789982577-516865
X-HE-Meta: U2FsdGVkX1/4/aw2GQVkUqnW2R9AKC254mOAVjx6FCjAs+ojajD5M9N6Ya0IizsdVRmmF5NOrF05lGJBRZ3f993mQkCgijtkcQGBOkknn4KOnRJe/U1zU77oAibr08SC9h+CIor1HEr58pinCfq0Sc4MRNoED6Imw5qOCxGJBtsKKc8gmJ2iAHguMMSdaS0QwvyxCDZL6RRlGvXnJXjzq82cVsZV7ZwZWCfFnTQQpYBQ0Up9jgJVYXBcmSNGbOlTSWSPxf7XkuqDT+LXZMnQr97TuTFD3v4wTTjdyYhNun86RfktIJyz0vAV1WATDyWFvbVlOfs/SzqBfVTMeHkbI7JhZG5BpV8DDBAfMRDUWFN4v2PthE73kXfQx4XycXRBaIEvF8WRrU6duoKm4qRpI068n5fBaZalRorXSgdLDCcrM1/EAr5U8hX/e+pLACoRAW1HpwxmXSIWWmtXmnSUJYSrqlKoiZBK5stGhOl280eqRxBG4R1uMBEBPBaPlWoLfTjntm/xsTq0A3hyghQFtHpywN865vXITkpgwDJl6zxPGmR1K7+ZMVhvSXM7+5eIe8qBbgAj8i3oHy6jYm2XQXSZ5pG7iyIjmSLDY8R3gpLpjBEx86LbexztcRBDwcLmjNf7g6UHY4AnS9nKCracabPtXlG1uMGPtuit2fHax+Pv6dS0xGDioqn3DE8tmTnIDGiSX4vGV8i8hBl5ZtECjJoflp5HhFwavMOr46nfKbuQV2SoudOzpHs+V9begxMMu8N79EwFbSAQ+6kjCp7SAd4Xm5vWTWlmjcafFnJ08h/Sk2ArEYRW28piz9nmmnlseAPsNxJaxDCEPQhNRFEG+svICdItkagrK4jSYqrBhbsG1xfTBNQWbHaR1GJ1BxfK+KtTjt6xPo155zZ/iGspbgf3NQuJZD+6AIFcbxV0IhOt+ceAH84/EeOYPZWntCyp/CNsRcQHv8vdy9MLPEA
 32xXWaVA
 +laSm70QOzQjp0mNPsTDd+lX+gd84IdBEhH8be4c9vKcz/IXcoas03BR/nC2BVpYS8xkjoB6j4Pj7faDMD0gfa+WkWY4WnoKCcJDilJ6nL3XyoMtcAH6SjLKfEC23b+phFSkuxvrt7SKSK3tIpjDRqSQ7B1pMdB3G5wY9W3gJsG1kpYnv0GPB5g2jyu43wV7QRqXjNXbu/FwlXzbYUc90sf1V8hrZSqbPyGofnPtdQxSr49/kBIQaUtKZgRN/RQXSVXhKmH3t1z/g5lMnGXfJbKsjUWpXdfIzSgINmqlrRN4RSU8ZYZ5O+XbjpGFAMnMzyYFwgv6Ta4njbn0qKfKqBAq9C9CRgCLtxxfAzPqzIk7/FQX+ZMPH/TJsuhHx9w5Tol1a4rfuiZFHpIgbdgY1nDktVRgulgCmuZqkXD+Swo5Sh1v+EBQ6/5ZaDBsLg/tihdh+Vg325xJiftM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_thread() loop in kernel/freezer.c with
for_each_thread_rculock(), which scopes the RCU read lock to the
loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/freezer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index a76bf957fb32..7a870f71dcf6 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -217,11 +217,9 @@ void thaw_process(struct task_struct *p)
 {
 	struct task_struct *t;
 
-	rcu_read_lock();
-	for_each_thread(p, t) {
+	for_each_thread_rculock(p, t) {
 		__thaw_task(t);
 	}
-	rcu_read_unlock();
 }
 
 /**
-- 
2.25.1


