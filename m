Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6932606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 10:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C166B05B2; Thu, 26 Nov 2026 05:23:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC816B05B3; Thu, 26 Nov 2026 05:23:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02E46B05B4; Thu, 26 Nov 2026 05:23:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A04BC6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:23:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 105EAA038E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:23:34 +0000 (UTC)
X-FDA: 85476883548.01.8F64B1C
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf02.hostedemail.com (Postfix) with ESMTP id E1A8F8000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:23:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of yangyizhen3198@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=yangyizhen3198@phytium.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795688612;
	b=8ZvCeSR7b208/QCkE/IbU8lCZLGR4TZdtf15rBzQeei8SFhyF3xPnC6yNZvuLl6OQeB3aE
	IfpWM7W/zgdzIxow1zRebpV63YEGVjzySIlZLj2Nl9hSgp8DqxpheWSapGEh9gTi5qYbHw
	2Cfp06KhPaorDsJUvSLCY0DqOSVAmgI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795688612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmKU+Dlh9ANeVOYNlhHjlgyLTWBBHO6m9V7nyxojBDw=;
	b=H7merwNecFzly8Fs5DlGt4U+UFKnI1NUfxsW2ldNa08ghEc3Q4nrhZQ7qYgiKhYGcRJfPo
	bbzzkbxqs9COhccNwUT/02VCEWQ2jNN/4bWuQpC+Aw0cE1iL9zQOHqiiyebwffN9lCHYWF
	0Ssyoo2FspG/slOB8JoW+licIGxdCso=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of yangyizhen3198@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=yangyizhen3198@phytium.com.cn
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with UTF8SMTP id AQAAfwC3vqacCAhrxzD5Bg--.10699S2;
	Thu, 26 Nov 2026 18:23:24 +0800 (CST)
Received: from remember_yyz (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAf8DwfXOZCAhrDgMAAQ--.49496S3;
	Thu, 26 Nov 2026 18:23:21 +0800 (CST)
Date: Thu, 26 Nov 2026 18:23:21 +0800
From: yangyizhen3198 <yangyizhen3198@phytium.com.cn>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, =?utf-8?Q?linux-block=40vger.kernel.org?=
 <linux-block@vger.kernel.org>, =?utf-8?Q?linux-fsdevel=40vger.kernel.org?=
 <linux-fsdevel@vger.kernel.org>, =?utf-8?Q?linux-mm=40kvack.org?=
 <linux-mm@kvack.org>, =?utf-8?Q?linux-kernel=40vger.kernel.org?=
 <linux-kernel@vger.kernel.org>
Message-ID: <762B3B28-2121-493B-904A-1016E9581B00@phytium.com.cn>
In-Reply-To: <20261120-hassliebe-arena-kaufvertrag-3ac58fd0483a@brauner>
References: <20261117105107.14236-1-yangyizhen3198@phytium.com.cn>
 <20261120-hassliebe-arena-kaufvertrag-3ac58fd0483a@brauner>
Subject: =?utf-8?Q?Re:__[RFC_PATCH_0/1]_block:_long_udev_open_waits_durin?=
 =?utf-8?Q?g_cache_teardown?=
X-Mailer: MailMasterPC/5.4.2.1011 (10.0.26200)
X-CUSTOM-MAIL-MASTER-SENT-ID: AD297E76-30B6-434C-8572-A039A1C2881D
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary="=_mailmaster-6b080899_0_29_="
X-CM-TRANSID:AQAAf8DwfXOZCAhrDgMAAQ--.49496S3
X-CM-SenderInfo: 51dqw5pl2kv0atrzmqxsk13x1xpou0fpof0/1tbiAQALDWsHN0wD-gABss
X-Coremail-Antispam: 1Uk129KBjvJXoW7Cr47Jw18Xry3CFyrGryDWrg_yoW8Xr13pa
	yqqa43Kr4qgF4UtFn7Zr1qg3yIkw4rAFW3JFn5GrWY93yFga4IqFW2vrWqv3W8JrZayrWY
	qw4qva95C3yDAFJanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspamd-Queue-Id: E1A8F8000A
X-Stat-Signature: by7jyipwskcimsjg6uktene5hwuk5f6t
X-Rspam-User:
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795688609-108406
X-HE-Meta: U2FsdGVkX1937TZLnIo7Xo8XwltSOyj43wM8R+XlmSwWGd4MDA3dd/4EKrn1ciMpsAiYElmsHOk40zh0VJw5vQTLK0CS5wu956nZylN4RN8lJYTkg7ZF61bjTKfCttUAROhESlbrJgbL3TWOS9Fb+MaKwmUt7sYvQhmRfAH+mmzYDFjQjMeEac2pbr9gPpwoET+AK/qoHhPwcupgcHv6CuRwDNzVb35dFH8OVAPbsVyNkLqhGujLH89sNwEzN+o86nhBCWWDeOG7jlv5So6tneGcedK7cAZv+XnpG9RXKb1J6fON70SeNZSQ/39PZZpDOXXpwWpR6pEvXeXIG4CfjwU8OBu8t+Fw45lCqSP9vGhT7fxfExbuhNv9eVAINJ7uy/iA63jMsw7axziEwqSHxNhIqVSOubJFcRTbu72OUHIyx7yS+Dh4f8Z8yQeY9f3T2Lz/z8nPLATbsvJhK7+UdvKQu2HAON+RxQVmSqeEmyq5hJU20pe9GLnH657yT+SAd05qEno1heIQNi8l1kaowSrJN1vntJ024m4SyRnj11W5QCrYIEkv9LZkqPQibC5qCRJnAFOGzMCv7e6U5vZz3v0nZraX09NZ6nH4CCs8vOPz5300sRo+ymqfFg2vCyAprgzfsoM1ZQJ3KRAdSqswYjJCo6TjKRr9LqfnIhJvcNEWw8bucQwrxfwMvQrbQI+sW+5KZDc2f+gMOdQWVFiYdcepvZRgE/q7ZIttZf8gTjyzjLdJZYdqkB8NFyrzxTOJNBvlVoKqLb07GS3ys6RGs6pDrkZo1+EGGRtBpIWq5EpL3dfDa3ugBS85tvu4gPQbHN0LJ+/KDh1vWsAbaXkGzwr+352+vV4wT/ppgp9YAfE9rZPWL8IG3prB2PrBOf0Eco72DJJQbkpe6haP3pv+67cghrKGv3PzFLDVrzX+rxRmO7i00kC3v0pz70qHcA67iC3SBYtsaiDCzcx1xWn
 bvuOvw9D
 /M2HyTsp2XhVhTcx3dzBI2hJ5uX49DkLkl9wnpb6E7b9gupYb0iNC3jNVS3VxtUfjJ3GJscah26CuM/3Y53ATnupZwfbo8QSSUEiTOKd1+9adHzN662l8VN1yFoE239lApby9VVtRkXJl5Wc4v+OVVfJYij9eWwVok9gHj/zsiisHYT8RlZfWOHFj6OH6+VXIdO8ONdkYVSJ+Zz4h/umnMhElOMLW7Hz/4LVfNxVdAwLcGzlGt7u4NRXSFC4OnA1nE0CL/N01lUyfLACNzWeAy2UkBTEH86g+grx2Jbp734MHX8L0r8648a//gKLeLBC/za19CnzzNatkAZpaTooPbs9OSEUIlmlt2+hUbSd9xAWtJlveheFBQX7gHwLiqfAueoDsORX/A/nwX9GKHhyt9ec3MtANyDWDfa5J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--=_mailmaster-6b080899_0_29_=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Christian, > If that still reproduces on mainline it's a question > about the bdev release locking. I reproduced the long udev open wait on upstream Linux v6.6 and on Linux v7.0.14. On both kernels, udev blocked while trying to open the device as mkfs.ntfs was closing it after a full format. Thanks for pointing out the impact on other openers. I agree that a udev probe closing its own file could trigger writeback and evict cache that another opener is still using. I'll drop the __fput() proposal. I'd like to understand the locking requirements in the block device last-close path. In particular, why does kill_bdev() need to complete while open_mutex is held? What state and ordering requirements does the lock protect during this cleanup? I'm asking because the device mapping can still contain a large amount of clean page cache after the early sync. In my tests on the vendor 6.6 kernel, about 805 GiB remained at final teardown, and the truncate took roughly seven minutes whil
 e udev w
as waiting. Could the release path be changed to reduce the time open_mutex is held while preserving those requirements? > And mkfs can just fsync() and POSIX_FADV_DONTNEED the device itself > before it closes it. I've submitted a patch to the ntfs-3g project that calls fsync() and then posix_fadvise(..., POSIX_FADV_DONTNEED) in userspace before closing the device. Thanks, Ethan
--=_mailmaster-6b080899_0_29_=
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: base64

PGh0bWw+PGhlYWQ+PG1ldGEgaHR0cC1lcXVpdj0nQ29udGVudC1UeXBlJyBjb250ZW50PSd0ZXh0
L2h0bWw7IGNoYXJzZXQ9VVRGLTgnPjwvaGVhZD48Ym9keSBzdHlsZT1saW5lLWhlaWdodDogMS41
O2ZvbnQtZmFtaWx5OiAi5b6u6L2v6ZuF6buRIj48ZGl2ICBzdHlsZT0iZm9udC1mYW1pbHk6IOW+
rui9r+mbhem7kTsiPjxkaXY+PHByZSBkaXI9Imx0ciI+PGNvZGU+SGkgQ2hyaXN0aWFuLAoKJmd0
OyBJZiB0aGF0IHN0aWxsIHJlcHJvZHVjZXMgb24gbWFpbmxpbmUgaXQncyBhIHF1ZXN0aW9uCiZn
dDsgYWJvdXQgdGhlIGJkZXYgcmVsZWFzZSBsb2NraW5nLgoKSSByZXByb2R1Y2VkIHRoZSBsb25n
IHVkZXYgb3BlbiB3YWl0IG9uIHVwc3RyZWFtIExpbnV4IHY2LjYgYW5kIG9uCkxpbnV4IHY3LjAu
MTQuIE9uIGJvdGgga2VybmVscywgdWRldiBibG9ja2VkIHdoaWxlIHRyeWluZyB0byBvcGVuIHRo
ZQpkZXZpY2UgYXMgbWtmcy5udGZzIHdhcyBjbG9zaW5nIGl0IGFmdGVyIGEgZnVsbCBmb3JtYXQu
CgpUaGFua3MgZm9yIHBvaW50aW5nIG91dCB0aGUgaW1wYWN0IG9uIG90aGVyIG9wZW5lcnMuIEkg
YWdyZWUgdGhhdCBhCnVkZXYgcHJvYmUgY2xvc2luZyBpdHMgb3duIGZpbGUgY291bGQgdHJpZ2dl
ciB3cml0ZWJhY2sgYW5kIGV2aWN0CmNhY2hlIHRoYXQgYW5vdGhlciBvcGVuZXIgaXMgc3RpbGwg
dXNpbmcuIEknbGwgZHJvcCB0aGUgX19mcHV0KCkKcHJvcG9zYWwuCgpJJ2QgbGlrZSB0byB1bmRl
cnN0YW5kIHRoZSBsb2NraW5nIHJlcXVpcmVtZW50cyBpbiB0aGUgYmxvY2sgZGV2aWNlCmxhc3Qt
Y2xvc2UgcGF0aC4gSW4gcGFydGljdWxhciwgd2h5IGRvZXMga2lsbF9iZGV2KCkgbmVlZCB0byBj
b21wbGV0ZQp3aGlsZSBvcGVuX211dGV4IGlzIGhlbGQ/IFdoYXQgc3RhdGUgYW5kIG9yZGVyaW5n
IHJlcXVpcmVtZW50cyBkb2VzCnRoZSBsb2NrIHByb3RlY3QgZHVyaW5nIHRoaXMgY2xlYW51cD8K
CkknbSBhc2tpbmcgYmVjYXVzZSB0aGUgZGV2aWNlIG1hcHBpbmcgY2FuIHN0aWxsIGNvbnRhaW4g
YSBsYXJnZQphbW91bnQgb2YgY2xlYW4gcGFnZSBjYWNoZSBhZnRlciB0aGUgZWFybHkgc3luYy4g
SW4gbXkgdGVzdHMgb24gdGhlCnZlbmRvciA2LjYga2VybmVsLCBhYm91dCA4MDUgR2lCIHJlbWFp
bmVkIGF0IGZpbmFsIHRlYXJkb3duLCBhbmQKdGhlIHRydW5jYXRlIHRvb2sgcm91Z2hseSBzZXZl
biBtaW51dGVzIHdoaWxlIHVkZXYgd2FzIHdhaXRpbmcuCkNvdWxkIHRoZSByZWxlYXNlIHBhdGgg
YmUgY2hhbmdlZCB0byByZWR1Y2UgdGhlIHRpbWUgb3Blbl9tdXRleCBpcwpoZWxkIHdoaWxlIHBy
ZXNlcnZpbmcgdGhvc2UgcmVxdWlyZW1lbnRzPwoKJmd0OyBBbmQgbWtmcyBjYW4ganVzdCBmc3lu
YygpIGFuZCBQT1NJWF9GQURWX0RPTlRORUVEIHRoZSBkZXZpY2UgaXRzZWxmCiZndDsgYmVmb3Jl
IGl0IGNsb3NlcyBpdC4KCkkndmUgc3VibWl0dGVkIGEgcGF0Y2ggdG8gdGhlIG50ZnMtM2cgcHJv
amVjdCB0aGF0IGNhbGxzIGZzeW5jKCkKYW5kIHRoZW4gcG9zaXhfZmFkdmlzZSguLi4sIFBPU0lY
X0ZBRFZfRE9OVE5FRUQpIGluIHVzZXJzcGFjZQpiZWZvcmUgY2xvc2luZyB0aGUgZGV2aWNlLgoK
VGhhbmtzLApFdGhhbjwvY29kZT48L3ByZT48L2Rpdj48L2Rpdj48IS0t8J+YgC0tPjwvYm9keT48
L2h0bWw+

--=_mailmaster-6b080899_0_29_=--


