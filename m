Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC30CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36FB8E01A2; Tue, 12 Aug 2025 23:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F1C8E019E; Tue, 12 Aug 2025 23:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B9A8E01A2; Tue, 12 Aug 2025 23:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82DC98E019E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:04:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F29F4C022B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:04:45 +0000 (UTC)
X-FDA: 83770241730.28.9EB1A5E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id A6C15A000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:04:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755054284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9u1EhT29l/fyxWfqnoLHJrSH5A8odeJNuLv5ms0nLw=;
	b=Zfg4OZJ+rJsVsbv+q9V4QwfWYNyMiZZzMQeZHEUHtibly+24Az2jgtSqGDT9JbIZwkujYe
	+TdWcfxHQCZ625rTuOidzRbfunb4kATrRQWkpP73VqiDqRJ1GV0CbuJN0fUVCJzkkcOwny
	LPRK8W2HnzxzlC2E2yRZ1ihS8pPLgzA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755054284; a=rsa-sha256;
	cv=none;
	b=EMXD9WqpnwwcPWPzelIxaZEeEEm1wmj7SncWJxVcz8A1xO08qzoV42RMPhLZ0/tKJ8K/TZ
	Etw9FtPjOf/9vMytGeExTD4jtfLqEvI9s59S2odxQHGpMnXFyiSxX/1+SjlWmiPZdSeomG
	V6eQwAjWik3zLlUIlAiu024T1f2z1Ms=
X-UUID: 3f547fcc77f211f0b29709d653e92f7d-20250813
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:61a2bf84-6726-42ca-bdc4-8c887ae87ba7,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:1
X-CID-INFO: VERSION:1.1.45,REQID:61a2bf84-6726-42ca-bdc4-8c887ae87ba7,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:1
X-CID-META: VersionHash:6493067,CLOUDID:354314cd71732fa740b5e7583b0f8b67,BulkI
	D:250813110438OSDH4HH7,BulkQuantity:0,Recheck:0,SF:17|19|24|45|64|66|78|80
	|81|82|83|102|841,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 3f547fcc77f211f0b29709d653e92f7d-20250813
X-User: lienze@kylinos.cn
Received: from kylin [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1277418137; Wed, 13 Aug 2025 11:04:37 +0800
From: Enze Li <lienze@kylinos.cn>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>,  SeongJae Park
 <sj@kernel.org>,  Shuah Khan <shuah@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  damon@lists.linux.dev,  linux-mm@kvack.org,
  linux-kselftest@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: q[PATCH] selftests/damon: fix damon selftests by installing
 _common.sh
In-Reply-To: <CABFDxMEQYx7fdx4T7meUb01FoqJaHcW_2RoYnBwJ8GzmJTexzQ@mail.gmail.com>
	(Sang-Heon Jeon's message of "Tue, 12 Aug 2025 22:27:00 +0900")
References: <20250812-alex-fixes_manual-v1-1-c4e99b1f80e4@rivosinc.com>
	<CABFDxMGPS6LE=A25VjXEpfKuzVfgxfgu=_uhkWXc3D+xuq-B6w@mail.gmail.com>
	<CABFDxMEQYx7fdx4T7meUb01FoqJaHcW_2RoYnBwJ8GzmJTexzQ@mail.gmail.com>
Date: Wed, 13 Aug 2025 11:04:33 +0800
Message-ID: <87v7mrvs5a.fsf_-_@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A6C15A000B
X-Rspam-User: 
X-Stat-Signature: 8qgpuguzccm6z8rp6y1q7ysgk1gzeu3t
X-Rspamd-Server: rspam09
X-HE-Tag: 1755054282-762778
X-HE-Meta: U2FsdGVkX19nqI4khrqQbU75maf+hcy4NqvNd5jP/eVQT3dWtl8+RlJQPGsfVvIgacZU7+IPijzJn2ob9V17aEmAQgTv3k8aK6tNP7dt0i7INNbQhZTObVW+Y1agoJ7HY2h4JbZcMTmZ+QHmeXuzS75ehXpFW+2zdJNtTRxJS2nNHSzQghEqsb15xWCySd1JF+IuUwHYgx48dmiCBuymDCxJAAkatuVjNrHTsNdzhai2xUEzq3PDlXK2eje9TnSpWcKMiVrK+T9CPj3ltJY82rbCdwdhyr1yTZAMha/YEG3ZoFPBw50wbqcO2+dqUU5ID2jYdzPz0JAmtWEBC0zVc0ogtYqsi9Id/tqvv6eoxhiL0gJyK+adKDS+F8UukWPMWIX7eGUe/J+nQE3rf1YyLbXrSIqvc8KPF6unudR1xNi7hAMB2g3d2I6M3BGHFp7uOOKBRYZZShEMsx2JJEoXPBE3tUhhLOF6igM0uhcwhsfXGVBEhq1vep6Te4kNPv9v7PEnUCEZ/HHvjBX4PSIQjPmd88TVSHSYJpuFuEo1GlidtNgomf8U6qZwLAk3W1One/ZmQvCgKstiM81IcobRBuXUoO9yZSwzUfGBp09r05SQwgkOgtbRpFzVcNOO5qoOhxdrzC2FH7MykTr1iEuGQ5TNK+0jCIYxcl68vI9BDxfrF1+Arty6UxPL9xK6Ig89+r7jLLbeF7EBDxNf0FBgYdFqTvxORo0JhVoiAmn9w7J8G8s5l/qEaEQmvlZT69YXEYiR/zaoQGlnJRthOw3fr6NYW7j2S7+DGyJf87JlRZihWu23SeUIG1+Lp5IgC9vEVWvjPEU9b/H2j033SuDfRQFMAyg8fAm/udKbq/oOLHMQDUjsB3/GgKA/yInioKDl66mv5xLAd2rXf2rRHoFxTFrQVQ4ebQaYOq2jVZJAcQNtx0F4VoFYxtosSxQv7hYwgeCu7Pb0CHSmIwZY81V
 zU5xCZwh
 PkVFbZbXOdgq+goL9nCXzJxTIjmR+DBI7H0HrXGAp5Uo4bWYFL0/4L3gyey2Af232e8XBwMgS464zDsySU0pXEMYFPLkLfBaY6m6G7mlthb9fnYva18tHRAYP0nUW9dM863d5+3tUzmNcSvmYMtFvn3XaB7VSQzGI+qNDM5sKFnUkLCE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Alexandre, Sang-Heon

On Tue, Aug 12 2025 at 10:27:00 PM +0900, Sang-Heon Jeon wrote:

> Hello, Alexandre
>
> On Tue, Aug 12, 2025 at 9:32=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail=
.com> wrote:
>>
>> Hello, Alexandre
>>
>> On Tue, Aug 12, 2025 at 5:13=E2=80=AFPM Alexandre Ghiti <alexghiti@rivos=
inc.com> wrote:
>> >
>> > _common.sh was recently introduced but is not installed and then
>> > triggers an error when trying to run the damon selftests:
>> >
>> > selftests: damon: sysfs.sh
>> > ./sysfs.sh: line 4: _common.sh: No such file or directory
>> >
>> > Install this file to avoid this error.

Excellent catch!  This patch unlocks a testing method that was
completely off my radar. :)

>>
>> I tried to reproduce those error with my vm environment but I failed;
>> with my workaround test method, it doesn't exist.
>> If you're okay, could you please tell me line by line how you execute
>> tests in what environment?
>> I'm also struggling with the test environment, as well.
>
> I succeeded to reproduce and also check that this patch removes those err=
ors.
>

Thanks to Sang-Heon for helping reproduce this issue.  I reproduce this
issue locally as well and I can confirm that this patch will fix it
successfully.

Here's my reproduction procedure:

  # cd /root/linux/
  # make -C tools/testing/selftests/ install INSTALL_PATH=3D/root/test-dir/
  # cd /root/test-dir/
  # ./run_kselftest.sh -c damon

and I got the following error,

  TAP version 13
  1..13
  # timeout set to 45
  # selftests: damon: sysfs.sh
  # ./sysfs.sh: line 4: _common.sh: No such file or directory
  # ./sysfs.sh: line 369: check_dependencies: command not found=20=20=20=20=
=20
  ok 1 selftests: damon: sysfs.sh

with Alexandre's patch applied, I got this,

  TAP version 13=20=20
  1..13
  # timeout set to 45
  # selftests: damon: sysfs.sh
  ok 1 selftests: damon: sysfs.sh

The root cause was my misunderstanding of the TEST_FILES macro.  I've now
refined the testing methodology - thanks all for the guidance.

Tested-by: Enze Li <lienze@kylinos.cn>

Best Regards,
Enze

>> > Fixes: 511914506d19 ("selftests/damon: introduce _common.sh to host sh=
ared function")
>> > Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
>> > ---
>
> Tested-by: Sang-Heon Jeon <ekffu200098@gmail.com>
>
>> >  tools/testing/selftests/damon/Makefile | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> > diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/se=
lftests/damon/Makefile
>> > index 5b230deb19e8ee6cee56eb8f18c35e12f331e8b7..ddc69e8bde2905ff1c461a=
08f2ad008e6b28ac87 100644
>> > --- a/tools/testing/selftests/damon/Makefile
>> > +++ b/tools/testing/selftests/damon/Makefile
>> > @@ -4,6 +4,7 @@
>> >  TEST_GEN_FILES +=3D access_memory access_memory_even
>> >
>> >  TEST_FILES =3D _damon_sysfs.py
>> > +TEST_FILES +=3D _common.sh
>> >
>> >  # functionality tests
>> >  TEST_PROGS +=3D sysfs.sh
>> >
>> > ---
>> > base-commit: 2754d549af31f8f029f02d02cd8e574676229b3d
>>
>> Does this commit exist in `mm-new` or `damon-next`?  I failed to setup
>> the same base-commit environment.
>
> However, I'm still not sure that this patch is in the correct
> baseline. maybe it will not cause any problems with the merge
> though... but I'm not sure. So I didn't add a reviewed-by tag.
>
>> > change-id: 20250812-alex-fixes_manual-aed3ef75dd83
>> >
>> > Best regards,
>> > --
>> > Alexandre Ghiti <alexghiti@rivosinc.com>
>> >
>> >
>>
>> Thank you for great work!
>>
>> Best Regards.
>> Sang-Heon Jeon
>
> Best Regards.
> Sang-Heon Jeon

