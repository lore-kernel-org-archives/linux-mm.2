Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 957E5CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8A46B0005; Thu, 28 May 2026 10:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80756B0088; Thu, 28 May 2026 10:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD046B008A; Thu, 28 May 2026 10:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCB176B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:28:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5AB8EA08B4
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:28:30 +0000 (UTC)
X-FDA: 84817059180.12.DCD0BDD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8B4D0A000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:28:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jgef1LBx;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779978508; a=rsa-sha256;
	cv=none;
	b=7gf9co7H+tvQYuEeucb1iJPcYPsi/bVfR7riLkzDaq9mT3jxnDHkpCZF1eBdt2gV2EcvyF
	1pItJjIiH/dRqe/MPF3tCx1I5D6C9htU1gP623KfO3ZoPVGAXVlmH7AIy/7NVW/bx+GBjt
	x6MlprNTQeDv1MKUiC36kLOX0FSOSqY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jgef1LBx;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779978508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EoTuaugOUgpppVjtGCkMKZAI0joZpdSN429TRVLx6SA=;
	b=s4hOd6is7H5P7miFMgFKeBsRLVNX1IeWzXuZExI+VRuBl5xwHzyvdKkKU/+qwLgJNtmNjb
	SFnf26SinTGqmZfSqR5PIt6/wZOe09B+vjK8Vq+MFnfPRkpCvouzEn19xWDOQL5GOl29l9
	+ut/PF/oBdW+k9Kqii/SgDcZqc+i3wM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8EAC40101;
	Thu, 28 May 2026 14:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493E31F000E9;
	Thu, 28 May 2026 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779978507;
	bh=EoTuaugOUgpppVjtGCkMKZAI0joZpdSN429TRVLx6SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jgef1LBxEC9c3bU8HLJOK1NHDewt8wbC75+D/S7/DJ01W+EeJSNc/Z3fJyMjCmCHx
	 3WfXJjMYvCpJ8Pc1GEJOZWN6+nZwRyMvz6DMRHYdUjcBYyxft6OIQv71Mha1ofiSKk
	 JXhABIx2Y/DElhEg2D3cx00BKphVODj6Kc0WYHP0lqvgbWf2X0sPTOe95lNiEt6Y12
	 xVhgE6fQ5FLx+6ILsldfhsFaOuBZXqjktMiaD8zN2FWpt/5cbgp/epRr/T05t2uk+4
	 2gOa5azMHCN7gJFQc5fyr0yGQoZ8hTKQ3t6nK5Gy2s16J1VkxpuprtK6WneKz/Ta/5
	 v8cEL37E65wmg==
From: SeongJae Park <sj@kernel.org>
To: niecheng <niecheng1@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: Re: [PATCH 2/2] selftests/damon: validate memcg filter sysfs readback
Date: Thu, 28 May 2026 07:28:18 -0700
Message-ID: <20260528142819.153573-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <406BD1BA0F6AE326+20260528081039.1192194-3-niecheng1@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B4D0A000B
X-Rspamd-Server: rspam03
X-Stat-Signature: 6x9su336zqqdt7dsmasxfcezm8y9epcu
X-HE-Tag: 1779978508-564937
X-HE-Meta: U2FsdGVkX1/5W6lYhBkGOR6ZCZuwpmStycSwktNhuRiQY5y9RwVD9eBR8fSYRHEXPTuwcMKGMFGDvilouP2ikNus5ZJjx9WjXgFPiCwce2a7FRjKDRmhXqvOR9FDFRssPey0itsM6xdW1M0YaTtlcPEfRt69DjdYMp9qVBQ7pV621FrKtQuYDUlywGKmkO/cHmDyHkOZXtQzmsnoiRo7jNbYTfsATCVKWKK7MbFDMBUdKtrQKJTRQkoft/qeO01F/3W/85kNPJYIMzSYkcLPhMItlVjv7x7enN5BGNHccH3HPQcsUpCqB7OVsVXS4VhyLn0mNicopR8/FLwqla9927zq1ajeYneoevhOjUKelYEuK1CB98aCp63DcHll8RbL8PljEEudZWKgtHmWBORujOUabTO/qfMiQCEfpvH67PQqbM+gd4fdhCdLasZhlrd/VqVoQ5V7Nsq8m+yYlEmeq3mLeObnsa4NSoehhTfNKPustJAaEC/I3qHdZn86TtyU4M0lZNOEX4lP4KxJXValPjNmrHvdM2Hu+nuCoug9Mu3bqi/qk7UteCoPudxBnXzr5i1ay7mWHQsoH4ujvoQXNwyK8R554DBgJNeCw1fQx7YvreQCRSlfveA4Moy6hC74kmG3x6fjiAa9euDVZt9hbrs5FyGTB4AnKQXQaVay73zJm9JpumtjgGjpdssv+dhltxtpjgi5l0w9EMMjtdKRaRcV4uMbzc18hjlJuED+ufTPWbCnHvDmr5MT9TtUHMK+BwxoArodLolV6ZjbbPGkcruaSPiPmVM5K1I3rRc7dlWamDPReuO9PQMQP6sDUyNM5PUFyb9mxfaExIXA0VCPR5uA0XSycGrEH5s+mCOqfLzk25pATpVcQtPKLJ1oN2kasM0BIv0N4qAh6TnS+1iTCGUpfeBf4eQF38Ww93Xh+R5aWYm7ybWtVwB+j7Gb6ROGuNkSdTwdawneRm8CKBO
 +hU+KnYf
 80ObUkT20UgUarkHikq/iZ3AHeW9s8o9vlpLoJ1dj9OrKRUNjGvBeC6iIqFOV4fuMFw7XqCCGluCPFNLqyJE9UAX6/6eHSkvT4BGs+xJEVH2VydCLxj0MMvn82bfgiso/86QC1bngzplWaWE1dsMYBKgWRE5yt9ycc4Jpca/6BXU0rfM73GjKBtrpNH9GBm7+YBvYcuzEQErXFuEgHXpYlukjjlTS7lF3GARY2PGpV9bhdYC2ju28Gp5EfPMCVso0pm7Hy0/i+CpK7OU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello niecheng,


Could we use 'selftests/damn/sysfs.py:' as the prefix of the subject?  That
will make it consistent with other commits and let us easily know to what test
this change is made.

On Thu, 28 May 2026 16:10:39 +0800 niecheng <niecheng1@uniontech.com> wrote:

> Add memcg filter validation to the DAMON sysfs selftest by checking the
> memcg_path sysfs readback.
> 
> Validate the readback path rather than a derived memcg_id so that the
> test stays focused on DAMON sysfs behavior and avoids depending on the
> local userspace cgroup mount layout.

Nice, thank you!

> 
> Also compare the readback path while stripping only the trailing
> newline.
> 
> Signed-off-by: niecheng <niecheng1@uniontech.com>
> ---
>  tools/testing/selftests/damon/sysfs.py | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> index 3aa5c91548a5..b595da24f698 100755
> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
> @@ -33,6 +33,7 @@ def assert_true(condition, expectation, status):
>      if condition is not True:
>          fail(expectation, status)
>  
> +
>  def assert_watermarks_committed(watermarks, dump):
>      wmark_metric_val = {
>              'none': 0,
> @@ -90,8 +91,14 @@ def assert_filter_committed(filter_, dump):
>      assert_true(filter_.type_ == dump['type'], 'type', dump)
>      assert_true(filter_.matching == dump['matching'], 'matching', dump)
>      assert_true(filter_.allow == dump['allow'], 'allow', dump)
> -    # TODO: check memcg_path and memcg_id if type is memcg
> -    if filter_.type_ == 'addr':
> +    if filter_.type_ == 'memcg':
> +        shown, rd_err = _damon_sysfs.read_file(
> +                os.path.join(filter_.sysfs_dir(), 'memcg_path'))
> +        if rd_err is not None:
> +            fail('memcg_path sysfs read', {'error': rd_err})
> +        assert_true(shown.rstrip('\n') == ('%s' % filter_.memcg_path),
> +                    'memcg_path_sysfs', dump)
> +    elif filter_.type_ == 'addr':
>          assert_true([filter_.addr_start, filter_.addr_end] ==
>                      dump['addr_range'], 'addr_range', dump)
>      elif filter_.type_ == 'target':

But this is in the middle of assert_filter_committed().  As the name says, this
is for validating if the user inputs are passed to DAMON internal.  I think
this is not the right place to test its 'staging' functionality.

> @@ -258,6 +265,8 @@ def main():
>                  ops_filters=[
>                      _damon_sysfs.DamosFilter(type_='anon', matching=True,
>                                               allow=True),
> +                    _damon_sysfs.DamosFilter(type_='memcg', matching=True,
> +                                             allow=True, memcg_path='/'),
>                      ],
>                  )])
>      context.idx = 0

What about adding another test case at the end of the main() function for the
validation of memcg string staging functionality?


Thanks,
SJ

[...]

