Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1EBCCD19F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713888E0089; Fri, 17 Oct 2025 09:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3F48E0006; Fri, 17 Oct 2025 09:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C218E0089; Fri, 17 Oct 2025 09:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F03A8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 062431DBF1B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:16 +0000 (UTC)
X-FDA: 84007737912.18.149B7B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6446F1C000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=ltfarP+2;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708954; a=rsa-sha256;
	cv=none;
	b=6cI5hmfGvSxzi5lMFceCoNuoahtfmSY3tR4Skm/vP5kM355xhQ3s6bbOee4f+SqOwlRfJR
	KSLKmy4TbwGw29BrAnsSJNxyj93Rw/O4NWi4wB2hvzE5SvcMa5O0dh1WrBksXbG/zIKelr
	5vGc0mTJrlPEePpLPuVOZVqlRpUHn2I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=ltfarP+2;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=xVQVKYUXJGhPBhUnGNwR5axfL//onxkclLjb9YP+0rQ=;
	b=jQrTgOJhkV1t2dkUAssnhtWtVA4o6WcZslaFsrWj2H9k5PVzUMDR340yde1LXPJfvZKGWi
	5ySVtL/JcFH2QvaVeNXZF2HuoyX3ygIIhnyzzClGm34DsEzJvq1RyAGc1MEnUNAajOfCTi
	OUUv7D7EtgE1vC8dMW+mlC08Ki+7Stk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8206164378;
	Fri, 17 Oct 2025 13:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D256BC4CEE7;
	Fri, 17 Oct 2025 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708953;
	bh=/SFhsPPhi3DTw2DVlHMYbfvarQ68KRPlJ5dKQf2wo5Y=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=ltfarP+2rXkk3f6zchK6vHPHoVrFh+Uip+PhTMq7KYU5Zm4iLOYROfs8sh+rWdOOy
	 cHgQoWBZmxirMehC+6J2KHCgfo+Vo1kXnI0RQ4SJ75n7xjFFmvU+9NeN53sPVxMv+9
	 T2ZerlqQFpL1VsSO+GPm+TX9MgnEu2m9guBl7hR0=
Subject: Patch "minmax: improve macro expansion and type checking" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	Jason@zx2c4.com, adilger.kernel@dilger.ca, agk@redhat.com,
	airlied@linux.ie, akpm@linux-foundation.org,
	alexander.deucher@amd.com, alexandre.torgue@st.com,
	amd-gfx@lists.freedesktop.org, andriy.shevchenko@linux.intel.com,
	anton.ivanov@cambridgegreys.com, arnd@kernel.org,
	artur.paszkiewicz@intel.com, bp@alien8.de, brian.starkey@arm.com,
	bvanassche@acm.org, chao@kernel.org, christian.koenig@amd.com,
	clm@fb.com, coreteam@netfilter.org, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	dm-devel@redhat.com, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsterba@suse.com, dushistov@mail.ru,
	evan.quan@amd.com, farbere@amazon.com, fery@cypress.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, harry.wentland@amd.com,
	hdegoede@redhat.com, herve.codina@bootlin.com, hpa@zytor.com,
	intel-linux-scu@intel.com, jack@suse.com, james.morse@arm.com,
	james.qian.wang@arm.com, jdelvare@suse.com, jdike@addtoit.com,
	jejb@linux.ibm.com, jmal@kvack.org, oy@redhat.com,
	joabreu@synopsys.com, josef@toxicpanda.com, kadlec@netfilter.org,
	kbusch@kernel.org, keescook@chromium.org, kuba@kernel.org,
	kuznet@ms2.inr.ac.ru, linux-arm-kernel@lists.infradead.org,
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
	linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-um@lists.infradead.org, linux@armlinux.org.uk,
	linux@rasmusvillemoes.dk, linux@roeck-us.net, liviu.dudau@arm.com,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	malattia@linux.it, martin.petersen@oracle.com, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	mihail.atanassov@arm.com, minchan@kernel.org, mingo@redhat.com,
	mripard@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
	ngupta@vflare.org, pablo@netfilter.org, peppe.cavallaro@st.com,
	peterz@infradead.org, pmladek@suse.com, qiuxu.zhuo@intel.com,
	rajur@chelsio.com, richard@nod.at, robdclark@gmail.com,
	rostedt@goodmis.org, rric@kernel.org, ruanjinjie@huawei.com,
	s@kvack.org, akari.ailus@linux.intel.com, sashal@kernel.org,
	sean@poorly.run, sergey.senozhatsky@gmail.com, snitzer@redhat.com,
	sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	torvalds@linux-foundation.org, tytso@mit.edu, tzimmermann@suse.de,
	willy@infradead.org, x86@kernel.org, xiang@kernel.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:30 +0200
In-Reply-To: <20251017090519.46992-20-farbere@amazon.com>
Message-ID: <2025101730-passing-upcountry-57a7@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Stat-Signature: 8sdhxnro8e3jcnu1jwn4rchhqnu7k756
X-Rspamd-Queue-Id: 6446F1C000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1760708954-252736
X-HE-Meta: U2FsdGVkX19cmwVnTRZ34Wu2QRknCsRbMYjzIZP7uN65YIPER3dW1s7kTPSYAlM8reH6o2D7pYO2aWQ9Bqwx/yG9ceLUnUDCENtSxxEAZF9omePOTLChys7y/xS+Q9pOaj4JrG6VYLPzwDITlp/x4ZwUWWIoWAF76Y1IOQaW/+wJ+1WvSHTNoPBynTICnC0rUGNvwSqasHmLRk3j8D/xVJDZy82r+qI+R5rBBxGKH7eDtYi47BKkX6wX5Dxmo/mfwCA4OzPlHwirAlMew0wv4I+yPTNlM18XcYB9bpWPHvrk4BbjbldXbeyabF2ph25eI7bveyuAZ26IGtrhOmPHNlvqavWm5YAlH/UUi3HynL8PntkSSe06XOe60JHu7LXKJp+wLLAJVOveBFCK5yOH5YFEgLSUNwktKCspVWjO7nijL5gbbxcMugnrmS9Ounsqnx9e/zNKnYSGXiOZUNXvaWJjNVgL7CLMa7JoQgHeYXwxX3FmriUuhAeZKIc2UoUUF0vlKxT6qH6dNTAIQZBDlSV+z2kAnu37zd64h28xbgRXwYELU7NsDSbNdFPrK1Q+jxv7n0TyM1RU7JBjvKMxzdnKqbPy6XZlPsywhhpGpSOE+020JwDgOLFzFybex6M5Xq7PDkwA17qGaJFpYzv94vZxPpc8CxszF85b9t1JgZfU0hYeZXwYtRuTn3nOqADBlrnedC2FcFD8DOBe8m7wa5E8+015DX5nFE9ObFnNA3c6RmgjMhMJPXMYMqrFkzYXdLZP+V5w7T5a88j51jXMVu/XTutvjKDHVDOynHJKu4/0YC0AFPN9QuNnyIIcxuA4dhPkDAbtbxzXc5dKzksYEMnoVWqEH2vBE7dhBQm/6ixJ6F5yDSnrJLQY5YrXoBurkJU8+2u0TscGMpB9mYci7JVzmb1H8NTTos/wnqOXPm7qxAGIomRoIRFbQArwhX8N6MnOzDIGFJM/8pf/J+s
 R7J/TO8w
 UhtDVhZwlUeJLsFrnvC9EMhdVO7vM+zpjFMwnTGERy/eW0gCi5GY3yPaQTIZjAVgJ2QUaA4SjZpo/35kre91EUm49YKBh2KTUjucS0nK+NTYt4YYBsP6IA9APkvMqRmYkkl8x0438ZQoViw8cmI63I7sjWrzyWc4CPvEagFUghcVgQRWoij2nyzt9fqpqKAQCD8jxleoLG6GD90WiU+nGWtrrQwKwUcazzlC6XXvXxLoWKcFopGYOwlEX0uIbZg76St0Vmf2ESojS8lpmVeEB0Duga8qjorx6Yoa0lBURQLWs+GFMfbML7PlBhpBK+C93Syn6AKbp4z9nTUMGgM7OeKwbCjjAm0VYf4RvhpiR7WyZVm9TmdsJDVpCj77pQmHSwjcWf8YQpdwckREXX/K68cEcbMVI509miu1vMmBcloi6+2kzcB8o3crn8EV3EDZ1viY5jTQHeI/6Q7QTCV1SzzDGdb7ZQ1aaKSVFdJvduG4KAiC3BYYyCDDnn63ZKnHBeHFo8ZszVclp1GwCVklrbkt8uXiM8Aj3gi3AmaPs7WXp+pV6ltnbCNsVh9AuJzBRZ/NuQ3fv/E3ByYBqB/x9KSTTN1OosgXzeYQa4W5Of0YBp834gaUDO8Lr8ip4bC4lfByP97m4MSBqF1ixVkVB0rx6mJMTJbTwXUh8aIeQmTHp8Yv+ybkM2j4ovnzia6+3NVKtF5zZCcTaAwEMs3Veg3lA6rfJiaj7cIJKNu/vM9B00eqawW+I+RtnNOpQ5hTBA5LBl4eGtocpWUM7hYeMxdDpQvBTpbrS1qZDwjU/hak9nnbTwmlS3PupgytioDqBkmcToyfd3DaKBmT3LE7i/L+w0/FMW2WA+JI9piDnyMlrU4EWOBp+VPMQg0ry+SRdpP5cdLFQY/2P3biGY8vPd4fGRF6RPbWrURLhdxmk2j+A5OwrA0q2Hc4u1l799SfnqE5B9I0FnK/3sm5rm3XpIEHGH4hU
 uTRBsu21
 JZRN64HMxP69cms3mU+vYQ0KikFZ5Dv7RQsvmBm01fVug9DPi6K0D0hTw6oEAQ+MjmMexB8kww8dL55UU+zd0LRaWxmiP/YKormlDofErU+i2ih3H0pwKrnlHTYrJF/+cOZr0o6aTnpzp6eEYXGX2Z/awdx5uVuazqFBTJd7zIbVgO9ZifkyXdxRdtbbr6RgOGGdbPKCLUI20duXOgvTZWV302aR/NLOBDWrxU/UCsSica7uRvFC1rmtsbSxpUThwOyjTAuwsuz1SPr3ZsMgw7U+p68BQrPJIGvqc+trVgJgnVWWgs5329Br3y9rGs2kebIYasn2wu96CXYv1FflK7AhaefwlV03vXkO/Al4krlukEPfyiy5TSYQyuMgW3B+oGNNE8skp/bpapZisDqB/v2Q/R+RCPL8XS2GivByKWYBv90YRgsqeoczVYskg2Wr+hRnBiyXoIobJZeZzs2nymAUXz2SB81HrVj9o/xASw5ItzTQNx+ixmivwvGVdDfdGZY85iZscxCSWVD5eqggU5Sexaxyyk/nASdDk5f8Cvu29b/FaWftHDRP5J0k7/OxEPh5FVKEV974YccGTrQWBzwunEBdAy1nj9Dcx+6hwv9/MJgnOqWJTYfW19LPwer1OqVE+W4JuHt2+zEviuTIX9ZnaMH3W+LM/OUxyyJ+nusVN8ZsXwbkJW/XOUZUPk21vyzdB+zvNGcJQZZ7XYhIKJHUyl+ViQ9ZWZDDHLZL8pRAEunJtrb97WDDJIk45BR15t3jZ2nar6OwHtBqeGgcoDjrNFWg389VXuhcVxgzWrAwaK5uotB5IyzvghnQ4v5uhuB1pB4dljAjLjaH3V0LQArWxrI+wLkwXvqh23fO60GMwBys3+DPFEM8pb2wlwTlhsCJZzyKFejGaGbpStdvuZbREHa+Dmr2GgL03NjCVHpnLDehRIgRun6KtC46P0KdwxNgdIxHxVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: improve macro expansion and type checking

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-improve-macro-expansion-and-type-checking.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:11:40 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:11 +0000
Subject: minmax: improve macro expansion and type checking
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann <arnd@kernel.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20251017090519.46992-20-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 22f5468731491e53356ba7c028f0fdea20b18e2c ]

This clarifies the rules for min()/max()/clamp() type checking and makes
them a much more efficient macro expansion.

In particular, we now look at the type and range of the inputs to see
whether they work together, generating a mask of acceptable comparisons,
and then just verifying that the inputs have a shared case:

 - an expression with a signed type can be used for
    (1) signed comparisons
    (2) unsigned comparisons if it is statically known to have a
        non-negative value

 - an expression with an unsigned type can be used for
    (3) unsigned comparison
    (4) signed comparisons if the type is smaller than 'int' and thus
        the C integer promotion rules will make it signed anyway

Here rule (1) and (3) are obvious, and rule (2) is important in order to
allow obvious trivial constants to be used together with unsigned
values.

Rule (4) is not necessarily a good idea, but matches what we used to do,
and we have extant cases of this situation in the kernel.  Notably with
bcachefs having an expression like

	min(bch2_bucket_sectors_dirty(a), ca->mi.bucket_size)

where bch2_bucket_sectors_dirty() returns an 's64', and
'ca->mi.bucket_size' is of type 'u16'.

Technically that bcachefs comparison is clearly sensible on a C type
level, because the 'u16' will go through the normal C integer promotion,
and become 'int', and then we're comparing two signed values and
everything looks sane.

However, it's not entirely clear that a 'min(s64,u16)' operation makes a
lot of conceptual sense, and it's possible that we will remove rule (4).
After all, the _reason_ we have these complicated type checks is exactly
that the C type promotion rules are not very intuitive.

But at least for now the rule is in place for backwards compatibility.

Also note that rule (2) existed before, but is hugely relaxed by this
commit.  It used to be true only for the simplest compile-time
non-negative integer constants.  The new macro model will allow cases
where the compiler can trivially see that an expression is non-negative
even if it isn't necessarily a constant.

For example, the amdgpu driver does

	min_t(size_t, sizeof(fru_info->serial), pia[addr] & 0x3F));

because our old 'min()' macro would see that 'pia[addr] & 0x3F' is of
type 'int' and clearly not a C constant expression, so doing a 'min()'
with a 'size_t' is a signedness violation.

Our new 'min()' macro still sees that 'pia[addr] & 0x3F' is of type
'int', but is smart enough to also see that it is clearly non-negative,
and thus would allow that case without any complaints.

Cc: Arnd Bergmann <arnd@kernel.org>
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler.h |    9 +++++
 include/linux/minmax.h   |   78 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 70 insertions(+), 17 deletions(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -252,6 +252,15 @@ static inline void *offset_to_ptr(const
 #define is_signed_type(type) (((type)(-1)) < (__force type)1)
 
 /*
+ * Useful shorthand for "is this condition known at compile-time?"
+ *
+ * Note that the condition may involve non-constant values,
+ * but the compiler may know enough about the details of the
+ * values to determine that the condition is statically true.
+ */
+#define statically_true(x) (__builtin_constant_p(x) && (x))
+
+/*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
  */
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -26,19 +26,63 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-/* is_signed_type() isn't a constexpr for pointer types */
-#define __is_signed(x) 								\
-	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
-		is_signed_type(typeof(x)), 0)
-
-/* True for a non-negative signed int constant */
-#define __is_noneg_int(x)	\
-	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
-
-#define __types_ok(x, y, ux, uy) 				\
-	(__is_signed(ux) == __is_signed(uy) ||			\
-	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
-	 __is_noneg_int(x) || __is_noneg_int(y))
+/*
+ * __sign_use for integer expressions:
+ *   bit #0 set if ok for unsigned comparisons
+ *   bit #1 set if ok for signed comparisons
+ *
+ * In particular, statically non-negative signed integer
+ * expressions are ok for both.
+ *
+ * NOTE! Unsigned types smaller than 'int' are implicitly
+ * converted to 'int' in expressions, and are accepted for
+ * signed conversions for now. This is debatable.
+ *
+ * Note that 'x' is the original expression, and 'ux' is
+ * the unique variable that contains the value.
+ *
+ * We use 'ux' for pure type checking, and 'x' for when
+ * we need to look at the value (but without evaluating
+ * it for side effects! Careful to only ever evaluate it
+ * with sizeof() or __builtin_constant_p() etc).
+ *
+ * Pointers end up being checked by the normal C type
+ * rules at the actual comparison, and these expressions
+ * only need to be careful to not cause warnings for
+ * pointer use.
+ */
+#define __signed_type_use(x,ux) (2+__is_nonneg(x,ux))
+#define __unsigned_type_use(x,ux) (1+2*(sizeof(ux)<4))
+#define __sign_use(x,ux) (is_signed_type(typeof(ux))? \
+	__signed_type_use(x,ux):__unsigned_type_use(x,ux))
+
+/*
+ * To avoid warnings about casting pointers to integers
+ * of different sizes, we need that special sign type.
+ *
+ * On 64-bit we can just always use 'long', since any
+ * integer or pointer type can just be cast to that.
+ *
+ * This does not work for 128-bit signed integers since
+ * the cast would truncate them, but we do not use s128
+ * types in the kernel (we do use 'u128', but they will
+ * be handled by the !is_signed_type() case).
+ *
+ * NOTE! The cast is there only to avoid any warnings
+ * from when values that aren't signed integer types.
+ */
+#ifdef CONFIG_64BIT
+  #define __signed_type(ux) long
+#else
+  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux)>4,1LL,1L))
+#endif
+#define __is_nonneg(x,ux) statically_true((__signed_type(ux))(x)>=0)
+
+#define __types_ok(x,y,ux,uy) \
+	(__sign_use(x,ux) & __sign_use(y,uy))
+
+#define __types_ok3(x,y,z,ux,uy,uz) \
+	(__sign_use(x,ux) & __sign_use(y,uy) & __sign_use(z,uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -53,8 +97,8 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	static_assert(__types_ok(x, y, ux, uy),		\
-		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	BUILD_BUG_ON_MSG(!__types_ok(x,y,ux,uy),	\
+		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
 #define __careful_cmp(op, x, y) \
@@ -70,8 +114,8 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	BUILD_BUG_ON_MSG(!__types_ok3(val,lo,hi,uval,ulo,uhi),			\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
 #define __careful_clamp(val, lo, hi) \


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.10/minmax-allow-comparisons-of-int-against-unsigned-char-short.patch
queue-5.10/minmax-add-a-few-more-min_t-max_t-users.patch
queue-5.10/minmax-improve-macro-expansion-and-type-checking.patch
queue-5.10/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.10/minmax.h-simplify-the-variants-of-clamp.patch
queue-5.10/minmax-add-in_range-macro.patch
queue-5.10/minmax.h-move-all-the-clamp-definitions-after-the-min-max-ones.patch
queue-5.10/minmax-allow-min-max-clamp-if-the-arguments-have-the-same-signedness.patch
queue-5.10/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-5.10/minmax.h-remove-some-defines-that-are-only-expanded-once.patch
queue-5.10/minmax.h-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
queue-5.10/minmax-simplify-min-max-clamp-implementation.patch
queue-5.10/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.10/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-5.10/minmax.h-add-whitespace-around-operators-and-after-commas.patch
queue-5.10/minmax-sanity-check-constant-bounds-when-clamping.patch
queue-5.10/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.10/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-5.10/minmax-fix-up-min3-and-max3-too.patch
queue-5.10/minmax.h-reduce-the-define-expansion-of-min-max-and-clamp.patch
queue-5.10/minmax-fix-header-inclusions.patch
queue-5.10/minmax-introduce-min-max-_array.patch
queue-5.10/btrfs-remove-duplicated-in_range-macro.patch
queue-5.10/overflow-tracing-define-the-is_signed_type-macro-once.patch
queue-5.10/minmax-relax-check-to-allow-comparison-between-unsigned-arguments-and-signed-constants.patch
queue-5.10/minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch
queue-5.10/minmax.h-update-some-comments.patch

