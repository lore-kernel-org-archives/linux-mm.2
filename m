Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F7EE674A4
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 12:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D2D6B0088; Mon, 22 Dec 2025 07:42:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820E76B0089; Mon, 22 Dec 2025 07:42:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D146B008A; Mon, 22 Dec 2025 07:42:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2296B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:42:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0710E140AF4
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 12:42:47 +0000 (UTC)
X-FDA: 84247071174.17.DE81D39
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 14F7E20010
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 12:42:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766407364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j3Y356LJBTe9eI/LB9gjKcTKFkUiiLEYhusq8tzpBCw=;
	b=RpButpT9JbRJ3QitbNq26pf7pzA2G0d98iCp/HRUOJXJUITcukNjIMZ/u3rqAgrJaHTvol
	L7A2Zwc+14TUGYwaPzsA9g0CvVNmQ7PoqtfDbSzHPMUI1keTiCVEXDDVwnRTJ7GSoeykIB
	Un6bWwjyZmqMuM7SZ8zgMZ0Hk7Oxky4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766407364; a=rsa-sha256;
	cv=none;
	b=eAHAzCbuk41h3FtRLj67wUvVfOVJASfELamQh3td2XOj1XCj/BMN0fanw6feJ1Nb1Bo2+w
	6E7+zvZXkgrTxLqlBb8Sj0r/+8SDB1A2lvM23LJ5yg55j2+FzNvnwkaz7A9RwuAo1QOY/i
	SX3LGchllSniV1NYqofUMeY2fTOHtxo=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dZd7Z1JNfzJ46fl;
	Mon, 22 Dec 2025 20:42:02 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id A69504056B;
	Mon, 22 Dec 2025 20:42:39 +0800 (CST)
Received: from [10.123.123.67] (10.123.123.67) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 15:42:36 +0300
Message-ID: <9be2ca36-0932-4237-aa0b-dd30161afe90@h-partners.com>
Date: Mon, 22 Dec 2025 15:42:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] mm: implement page refcount locking via dedicated
 bit
To: Gregory Price <gourry@gourry.net>
CC: <patchwork@huawei.com>, <guohanjun@huawei.com>,
	<wangkefeng.wang@huawei.com>, <weiyongjun1@huawei.com>,
	<yusongping@huawei.com>, <leijitang@huawei.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <alexander.grubnikov@huawei.com>,
	<gorbunov.ivan@h-partners.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<ziy@nvidia.com>, <harry.yoo@oracle.com>, <willy@infradead.org>,
	<yuzhao@google.com>, <baolin.wang@linux.alibaba.com>,
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <81e3c45f49bdac231e831ec7ba09ef42fbb77930.1766145604.git.gladyshev.ilya1@h-partners.com>
 <aUWWn3YMOrPdyY_c@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
In-Reply-To: <aUWWn3YMOrPdyY_c@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.67]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 14F7E20010
X-Stat-Signature: sags9dr1au6m43okey887n4za4nk7u5x
X-Rspam-User: 
X-HE-Tag: 1766407363-169186
X-HE-Meta: U2FsdGVkX196Ebw1BAaAhKFBI7XcQcdenuFGYwZD4r0/DtCteW1C5m6O8Ym6QgPyzqtGtwFzX9FoHvf7fJDoNkmCtH9wW3Edj6FeigQAtOc4XGOwnHOaJrvBmXxko+F384x9hv6M72uBhwhw10ERqyGKa48E+Kxdnq/MCaPCcgMcWCbW8KztVlSiWEgVP+wCV4dnbWz2MyGZXwG00+J6vkio4cke7RSvZsaosLWBu2aT2tKmRCYLYv8RwB6DWGun5cZui9wn8aW3RcJCr8+VVw5km1BsT/b7yJ5A0kW14mGbKCZEqV5xZ33uGF75/M7JrNeY2Eb72wkB+xDs+vFmqfjlJyCW0ckbn/1BqVvXy04qtgZiDPQQApZFh0GSnklkR13PKlJxo1S4WDEO3XtEQlAVq6Us+RZsE1HMr64zYiu3TaQHm5lBaTQCISsu6VjaKLloVNOB30MkOiXJDxSLy4pQrDptYTll+eWZs4knbG/gNFPmk4p/DAJbNL9r9iHZ2h2fz5uvidBNOmTiOm853LcwSAxHatz+viDXTXBU9GsbU0lJRkGs5lBxzcY6bf+XL0YccPZctWdtHz5XkwBETrgzY/G3aoVx8xJ4ZAzQUptjHu/E7vKncmyaBqyaWD1I2XYccERvOiw9n5CVZP8XJ9ydk3qk5N6Gbniscxc0fSVad/N7IQ1/i+rPaRcLTJWUrFozb4U/qD0w1CvcKjuyZccrFmyERf5vPttUw2x0VgnHjftXqte/iob+y+ATAzaVixvw3+JtTGHCxzrN9y1itK6lHuvOOMaY0iFySNOLfqCBAZGLLcRforuiulmhgfePvYrDbHpjA1gq5QIIKlDnjnWnh+R7uWA3ibPxuAZGehafjZbYlD4c+Ns8Hl8qn6R0yWSHc6+S95zXBNcLKxnQ1DME56+hPFfsqtsziCGTRD8bm0RJl0su1MZxbXG+KHvbc/LeY4NujzLGy2y18ry
 FHPrf0XG
 aJtUYf5GnhUnduufe0XfsaJEO/8BLdOjJO7TmK+IHnauo4SjS7pdbq06bAxcmhT1ydbgoyog7+DTvvYyHE4k4wylAi4hC/vl8f9f5nxe2lfxHGldroskGfRuD/2+zuQaKsBiFs+r77y08Pc79E5mR3bPpi739QxhgTFlW5dIGn16RIq0YtNWt+fFfL8Av1fopDCi/0/V21LcAC2+Af/q47dMUKGBEKQDtMZJQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/2025 9:17 PM, Gregory Price wrote:
> On Fri, Dec 19, 2025 at 12:46:39PM +0000, Gladyshev Ilya wrote:
>> The current atomic-based page refcount implementation treats zero
>> counter as dead and requires a compare-and-swap loop in folio_try_get()
>> to prevent incrementing a dead refcount. This CAS loop acts as a
>> serialization point and can become a significant bottleneck during
>> high-frequency file read operations.
>>
>> This patch introduces FOLIO_LOCKED_BIT to distinguish between a
>> (temporary) zero refcount and a locked (dead/frozen) state. Because now
>> incrementing counter doesn't affect it's locked/unlocked state, it is
>> possible to use an optimistic atomic_fetch_add() in
>> page_ref_add_unless_zero() that operates independently of the locked bit.
>> The locked state is handled after the increment attempt, eliminating the
>> need for the CAS loop.
>>
> 
> Such a fundamental change needs additional validation to show there's no
> obvious failures.  Have you run this through a model checker to verify
> the only failure condition is the 2^31 overflow condition you describe?
Aside from extensive logical reasoning, I validated some racy situations 
via tools/memory-model model checking:
1. Increment vs. free race (bad output: use-after-free | memory leak)
2. Free vs. free race (bad output: double free | memory leak)
3. Increment vs. freeze (bad output: both fails)
4. Increment vs. unfreeze (bad output: missed increment)

If there are other scenarios you are concerned about, I will model them 
as well. You can find the litmus tests at the end of this email.
> A single benchmark and a short changelog is leaves me very uneasy about
> such a change.
This RFC submission was primarily focused on demonstrating the concept 
and the performance gain for the reported bottleneck. I will improve the 
changelog (and safety reasoning) for later submissions, as well as the 
benchmarking side.

---

Note: I used 32 as locked bit in model tests for better readability. It 
doesn't affect anything

---

diff --git 
a/tools/memory-model/litmus-tests/folio_refcount/free_free_race.litmus 
b/tools/memory-model/litmus-tests/folio_refcount/free_free_race.litmus
new file mode 100644
index 000000000000..4dc7e899245b
--- /dev/null
+++ b/tools/memory-model/litmus-tests/folio_refcount/free_free_race.litmus
@@ -0,0 +1,37 @@
+C free_vs_free_race
+
+(* Result: Never
+ *
+ * Both P0 and P1 tries to decrement refcount.
+ *
+ * Expected result: only one deallocation (r0 xor r1 == 1)
+ * which is equal to r0 != r1 => bad result is r0 == r1
+*)
+
+{
+       int refcount = 2;
+}
+
+P0(int *refcount)
+{
+       int r0;
+
+       r0 = atomic_dec_and_test(refcount);
+       if (r0) {
+               r0 = atomic_cmpxchg_relaxed(refcount, 0, 32) == 0;
+       }
+}
+
+
+P1(int *refcount)
+{
+       int r1;
+
+       r1 = atomic_dec_and_test(refcount);
+       if (r1) {
+               r1 = atomic_cmpxchg_relaxed(refcount, 0, 32) == 0;
+       }
+}
+
+exists (0:r0 == 1:r1)
+
diff --git 
a/tools/memory-model/litmus-tests/folio_refcount/inc_free_race.litmus 
b/tools/memory-model/litmus-tests/folio_refcount/inc_free_race.litmus
new file mode 100644
index 000000000000..863abba48415
--- /dev/null
+++ b/tools/memory-model/litmus-tests/folio_refcount/inc_free_race.litmus
@@ -0,0 +1,34 @@
+C inc_free_race
+
+(* Result: Never
+ *
+ * P0 tries to decrement free object.
+ * P1 tries to acquire it.
+ * Expected result: one of them failes (r0 xor r1 == 1),
+ *   so bad result is r0 == r1
+*)
+
+{
+       int refcount = 1;
+}
+
+P0(int *refcount)
+{
+       int r0;
+
+       r0 = atomic_dec_and_test(refcount);
+       if (r0) {
+               r0 = atomic_cmpxchg_relaxed(refcount, 0, 32) == 0;
+       }
+}
+
+
+P1(int *refcount)
+{
+       int r1;
+
+       r1 = atomic_add_return(1, refcount);
+       r1 = (r1 & (32)) == 0;
+}
+
+exists (0:r0 == 1:r1)
diff --git 
a/tools/memory-model/litmus-tests/folio_refcount/inc_freeze_race.litmus 
b/tools/memory-model/litmus-tests/folio_refcount/inc_freeze_race.litmus
new file mode 100644
index 000000000000..6e3a4112080c
--- /dev/null
+++ b/tools/memory-model/litmus-tests/folio_refcount/inc_freeze_race.litmus
@@ -0,0 +1,31 @@
+C inc_freeze_race
+
+(* Result: Never
+ *
+ * P0 tries to freeze counter with value 3 (can be arbitary).
+ * P1 tries to acquire reference.
+ * Expected result: one of them failes (r0 xor r1 == 1),
+ *   so bad result is r0 == r1 (= 0, 1).
+*)
+
+{
+       int refcount = 3;
+}
+
+P0(int *refcount)
+{
+       int r0;
+
+       r0 = atomic_cmpxchg(refcount, 3, 32);
+}
+
+
+P1(int *refcount)
+{
+       int r0;
+
+       r0 = atomic_add_return(1, refcount);
+       r0 = (r0 & (32)) == 0;
+}
+
+exists (0:r0 == 1:r0)
diff --git 
a/tools/memory-model/litmus-tests/folio_refcount/inc_unfreeze_race.litmus 
b/tools/memory-model/litmus-tests/folio_refcount/inc_unfreeze_race.litmus
new file mode 100644
index 000000000000..f7e2273fe7da
--- /dev/null
+++ 
b/tools/memory-model/litmus-tests/folio_refcount/inc_unfreeze_race.litmus
@@ -0,0 +1,30 @@
+C inc_unfreeze_race
+
+(* Result: Never
+ *
+ * P0 tries to unfreeze refcount with saved value 3
+ * P1 tries to acquire reference.
+ *
+ * Expected result: P1 fails or in the end refcount is 4
+ * Bad result: Missed refcount
+*)
+
+{
+       int refcount = 32;
+}
+
+P0(int *refcount)
+{
+       smp_store_release(refcount, 3);
+}
+
+
+P1(int *refcount)
+{
+       int r0;
+
+       r0 = atomic_add_return(1, refcount);
+       r0 = (r0 & (32)) == 0;
+}
+
+exists (1:r0=1 /\ refcount != 4)


