Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750F2C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 16:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0006B0088; Mon, 28 Jul 2025 12:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80B46B0089; Mon, 28 Jul 2025 12:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70176B008A; Mon, 28 Jul 2025 12:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C97A26B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:55:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 787CC160361
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:55:55 +0000 (UTC)
X-FDA: 83714275470.23.D1A76C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D962B18000B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:55:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKTrzBoG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753721753; a=rsa-sha256;
	cv=none;
	b=7re4tgEQlfndTtyl7f66dDJDgoi+aTvt6rBJB2zt0UfNkjpkQbXMYEVYs9LVK1yQ0oSB4e
	x0o6TWHABdcz0K39APTZlJquqyHTWBc+CFF+VGhyeqRsJ8MiOLpfZZHWY2l6fF3EVaKXkS
	3WMR4vkDFDtpFFUxcyPTmzXBxZHsEng=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKTrzBoG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753721753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmjI/Z3HB73LaDE6GF0ftzCT8oEFHeWFdL7Knzgt7yc=;
	b=DJ1BfvzZPFMtDH9XeSxtJNcXnH/KtdrVz9gHdzneZL8X1tyjTn+mggVIOsfVZ6guPLB1c3
	csVlAxmJYCoJ0iQeaks/wzgE28+K6FI9iFkSejzJ0XsHgiV2fNwTjTVU8cELk8b3HkgGpP
	uQvKXRHc8V66H0ZaWkg5x4fPgcDqVhA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00CAB601EA;
	Mon, 28 Jul 2025 16:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8146DC4CEE7;
	Mon, 28 Jul 2025 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753721752;
	bh=NQFaFtTN7N6BCj6w0IBTYBXcpqLFYEKBc4izu1Pcojo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKTrzBoG5SYEOWdZuwKRnsIaC3w6XuxfTZaFJLGqJ35KqvCGFbFKbP/Zw6QrXTMjh
	 pGlx/nuMebKFFIX+3EJxaX5FTM5wRXtSIwYxipv9GK53Vc4oIfF18F3kEqOM6mBb7K
	 8IaBXa/vJx5IhcWufXsj2TINNTL3q0dC244iiZS8li6hGUgs4ZPN5jinPNlEcDVhvd
	 EuMLqKdNgIr5tUtL9RVJbaQIohQmDM9A3lSECcFV6At8+rRoRfFYLiZdqm1qGyuzHF
	 NxTWzk4f4VY94O4I1a72SpeVP5Gx8lgWFAUoze8SO1S+rS/loRr6bfmMVwXgmjU6fr
	 VoQrdZZkIR8Tg==
From: SeongJae Park <sj@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 5/5] selftests: prctl: introduce tests for disabling THPs except for madvise
Date: Mon, 28 Jul 2025 09:55:49 -0700
Message-Id: <20250728165549.62546-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250725162258.1043176-6-usamaarif642@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D962B18000B
X-Stat-Signature: n31wfcrj14njb3mednkobox5c5y3msn1
X-Rspam-User: 
X-HE-Tag: 1753721753-632343
X-HE-Meta: U2FsdGVkX1+74rmMh9nhdXCBOI2lfChqEOMjfhMnO+uPFBipFbWn46IrPcWCAe2DdcQXT3SxdfTRpmgD0gazOzuhJBUTW0Q+pRWxfJf5ack6rfxuMaTzgzXcEMZrmV9owoYxgd20MNxUj/3U+uq1LjPTTFwG6MYSIsT31auNjWcxFB3bdCg0rg5DKThmZxUrutiBV1if7Zpw01L54Rm7h0TzCQRlWLFuLNanea4i0YRo9jgYOAeaW4MV3Si8v+PrgP1cyAc1tXrrWp+hw6EiQh7d3AuieSYSECcMQkX3+cWjztLRTpngnLVCkD0x6vt3qTxRQWbL/xLPLmmqITw+SVMRkRt47rHGjjCLd4QXUkg9LrepGQHkzmaM2OAh/F3DeQbYiaKb+hcJ4aslTDCqD0ESlX3/Zh2c6OJJRgHFCTcMMoO/Ok/wTqAVscmu6C0SqE1rRwmDqiw1Icogowl+qOTPC7/iqOJLaY/1TzzktWi+ZnZGM051VKa8B3d6Sy6xuP0YjGy57ornd0pPhV+0I8mjq9ITDL5bA0znFeJd2YdezXvmrdgNZdKHJl5wb8sBl4HKRTNvAOl/kgrTFLzpEmL8NgY3zSST1pe9bvjOfLRzYjdDGAf9r15VSz45tGBh0RiPKImmDfNePUOCqzGyzqGY0s9KKoP10vgOG5mzLpxuOMhbpip81m4TNwc/Ppp4+7UmV8H7W0vgV5a+FgQpG4qabvIBv6IIMaeUZVAYPPjN11akScThh1/QgLwplpKxfz8ZGZpv8OLjVxDWQPr4QSHDpRMYkKgOcxrZeRDvKanN4hVXsugDXQuAAhTGTYezCIwqh1nCJJswYaRFDqAAe5uFDyT3Ou6oBVYDs0CP3dI3IU2NDvJL5TdpNTGh6T9NwPh3lfuQ3UoEsQNyAw2cCjo3HKPw/Csds1s8Qk/olBpYT5VnT3opNfVOB4uSyLfZR6jl5MUAo7E0C95yRZ4
 QHQR6KYI
 N3i3yJHllZEUrowAnQJBk4a3YYvquDrcq3N9y3qJfd7Qrkghc/F1q4f+Z8fjL7pSnZIkXKrN3ARpZLAcJXA4cWWQNSNdv5bP9ItZW3TEVNv+IOsoOsoodWpNqI8I3ZUYHyeLlsHNWnecn0+GjlaJ3gn3pHiE/kgehC1kvj+v6ALojphoqZZQMMlED7zJZ9tAJTtOas5wakqIWf6ZUWxtMFeSMY17QlQRWzGEiwbTgazQXga5u2gYyfToxHzW+oiQCIcdTB8Gf8ar+HwnTFLxQSu1xNePmJ6e7eGj+lwtioRhV5kxONaPGBANpjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025 17:22:44 +0100 Usama Arif <usamaarif642@gmail.com> wrote:

> The test will set the global system THP setting to always and
> the 2M setting to inherit before it starts (and reset to original
> at teardown)
> 
> This tests if the process can:
> - successfully set and get the policy to disable THPs expect for madvise.

s/expect/except/

> - get hugepages only on MADV_HUGE and MADV_COLLAPSE after policy is set.
> - successfully reset the policy of the process.
> - get hugepages always after reset.
> - repeat the above tests in a forked process to make sure  the policy is
>   carried across forks.
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---
>  .../testing/selftests/mm/prctl_thp_disable.c  | 95 +++++++++++++++++++
>  1 file changed, 95 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
> index 52f7e6659b1f..288d5ad6ffbb 100644
> --- a/tools/testing/selftests/mm/prctl_thp_disable.c
> +++ b/tools/testing/selftests/mm/prctl_thp_disable.c
> @@ -65,6 +65,101 @@ static int test_mmap_thp(enum madvise_buffer madvise_buf, size_t pmdsize)
>  	munmap(buffer, buf_size);
>  	return ret;
>  }
> +
> +FIXTURE(prctl_thp_disable_except_madvise)
> +{
> +	struct thp_settings settings;
> +	size_t pmdsize;
> +};
> +
> +FIXTURE_SETUP(prctl_thp_disable_except_madvise)
> +{
> +	if (!thp_is_enabled())
> +		SKIP(return, "Transparent Hugepages not available\n");

As David also pointed out on the other patch, the message and the function name
would better to be consistent.

> +
> +	self->pmdsize = read_pmd_pagesize();
> +	if (!self->pmdsize)
> +		SKIP(return, "Unable to read PMD size\n");
> +
> +	thp_read_settings(&self->settings);
> +	self->settings.thp_enabled = THP_ALWAYS;
> +	self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
> +	thp_save_settings();
> +	thp_push_settings(&self->settings);
> +

Unnecessary empty line?

> +}
> +
> +FIXTURE_TEARDOWN(prctl_thp_disable_except_madvise)
> +{
> +	thp_restore_settings();
> +}
> +
> +/* prctl_thp_disable_except_madvise fixture sets system THP setting to always */
> +static void prctl_thp_disable_except_madvise(struct __test_metadata *const _metadata,
> +					     size_t pmdsize)
> +{
> +	int res = 0;
> +
> +	res = prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL);
> +	ASSERT_EQ(res, 3);
> +
> +	/* global = always, process = madvise, we shouldn't get HPs without madvise */
> +	res = test_mmap_thp(NONE, pmdsize);
> +	ASSERT_EQ(res, 0);
> +
> +	res = test_mmap_thp(HUGE, pmdsize);
> +	ASSERT_EQ(res, 1);
> +
> +	res = test_mmap_thp(COLLAPSE, pmdsize);
> +	ASSERT_EQ(res, 1);
> +
> +	/* Reset to system policy */
> +	res =  prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL);
> +	ASSERT_EQ(res, 0);
> +
> +	/* global = always, hence we should get HPs without madvise */
> +	res = test_mmap_thp(NONE, pmdsize);
> +	ASSERT_EQ(res, 1);
> +
> +	res = test_mmap_thp(HUGE, pmdsize);
> +	ASSERT_EQ(res, 1);
> +
> +	res = test_mmap_thp(COLLAPSE, pmdsize);
> +	ASSERT_EQ(res, 1);

Seems res is not being used other than saving the return value for assertions.
Why don't you do the assertion at once, e.g., ASSERT_EQ(test_mmap_thp(...), 1)?
No strong opinion, but I think that could make code shorter and easier to read.

> +}
> +
> +TEST_F(prctl_thp_disable_except_madvise, nofork)
> +{
> +	int res = 0;
> +
> +	res = prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL);
> +	ASSERT_EQ(res, 0);

Again, I think 'res' can be removed.

> +	prctl_thp_disable_except_madvise(_metadata, self->pmdsize);
> +}
> +
> +TEST_F(prctl_thp_disable_except_madvise, fork)
> +{
> +	int res = 0, ret = 0;
> +	pid_t pid;
> +
> +	res = prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL);
> +	ASSERT_EQ(res, 0);

Ditto.

> +
> +	/* Make sure prctl changes are carried across fork */
> +	pid = fork();
> +	ASSERT_GE(pid, 0);
> +
> +	if (!pid)
> +		prctl_thp_disable_except_madvise(_metadata, self->pmdsize);
> +
> +	wait(&ret);
> +	if (WIFEXITED(ret))
> +		ret = WEXITSTATUS(ret);
> +	else
> +		ret = -EINVAL;
> +	ASSERT_EQ(ret, 0);
> +}
> +
>  FIXTURE(prctl_thp_disable_completely)
>  {
>  	struct thp_settings settings;
> -- 
> 2.47.3


Thanks,
SJ

