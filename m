Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0E3606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gt+MBOJ9
Received: by kanga.kvack.org (Postfix)
	id 2741F6B00EF; Fri, 20 Nov 2026 09:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225366B05B1; Fri, 20 Nov 2026 09:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C4C6B05B3; Fri, 20 Nov 2026 09:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E59646B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:29:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6DB04C0F6D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:29:28 +0000 (UTC)
X-FDA: 85455730416.29.2452408
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C313B4000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:29:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gt+MBOJ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795184966;
	b=fshvm8K52j02HGw+Wtpzi85D7W+Mv2js7RufP/M7/T2rMwD5obEpoIB74/JzVfAynrkzMD
	1s9eyE9Diz1/dVpWmYOUAMA1raeT9WSsoOglBTaPwog30enf/EZiCy02dijOA8I1a5iDl8
	W2OiThwrHVG6Zk9fZbZsSvgdGjRhgok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795184966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhOyoytlnDVzUE3pO2YswTduW+qVAkiRX4Xy+qDagYo=;
	b=3jkNNeR4Z8h5eeCEFrdG3Qr6SD71K8Bm02eFg6BR5DeL0dhSZEuMeUbq3+AqnaOOO1PUHP
	MaXqPIGWln5rToezXod4M6pSaP0YVQ50l7AnDi3fVQTSWpkJ4EZAXQ2cfwxR2gp0632GYq
	cfpASQ1XiH0naHBBNkrg+JWilSDuJog=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gt+MBOJ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 429386159A;
	Fri, 20 Nov 2026 14:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EB61F000C0;
	Fri, 20 Nov 2026 14:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795184965;
	bh=rhOyoytlnDVzUE3pO2YswTduW+qVAkiRX4Xy+qDagYo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Gt+MBOJ99ecdCoik/DrDTQPtJz5L/ZTUyz/EegTnM9kepvs1tpxlCXOv1QgdhAHCu
	 Rmea41jfXufLIE9H7uiBcy5CTMLzjfkcfLsQwgixDcr/U+q3RoZbmZZMqNU1OAuVv/
	 aJL0k0omtXBWH1QfEfPodlrJd6YnP4ktpCjHBX2T/Fj/2sJEv9VCS9VsIA1i/Liuxu
	 mjSFcrKqc8hvKpD9cZWD9ytUtBRRiNqbPEoe3oRte2J3A84utdWKl3hIvZBKhIlmeu
	 KXKHkErlt1fr1FyS1G4E4e0/dmYnunLescQcyb+4VQwLXaMDFM8m3apbWo/ePA8e0j
	 9v3XLNMi3UdSw==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4 14/19] selftests/liveupdate: Test which tmpfs files
 can be preserved
In-Reply-To: <20261111002358.1842967-15-dmatlack@google.com> (David Matlack's
	message of "Wed, 11 Nov 2026 00:23:52 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-15-dmatlack@google.com>
Date: Fri, 20 Nov 2026 14:29:19 +0000
Message-ID: <2vxzh5hb1sqo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User:
X-Rspamd-Queue-Id: C313B4000C
X-Stat-Signature: bpjw5ofxibide3xk61373f6pmnusof1a
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795184966-180742
X-HE-Meta: U2FsdGVkX1/rVqcW0kIV8hAGF34UFWmgDslLbn3k2gat4XZ/XcSvjQPRtvsda2E762nFRSH30CXbiw2Fd/svZ6o+2RE+v6H9DmbdP/rPH6JKZF9pYcEjLkEdfxPkpZbBbXbYLut8KkC8igAO9T5tIEq3XfRHuTMfRzuhApKVRImDCNCBML1Sg+5ITFcDiGWj/lVrtFD19osyxj9UgtjOdafryurNnHpLph41QpmrFxBxkT6N7oemcvz76n+uuGtrPk4EhhKavDJYVwUF8pFNefEHj22U0AMlA0Ca9k1Zof6J5qNs2uc/exA7R4B6t7YhLTooC6u3c+eA079WrmZj0AdwyLSSl6spJzyJh4ILEpavBMuKEgY2DaL/zrdQ5Zi4UAEzLA9WLmLFAINSAYupkM5cGpkq3bc/M5qkEFTHFqJylMTqL63EOr8in6IAuvgXsp/zuTlZ7wLhGyMaL+p5E/VLozbKxHl58kUIQny/VHqlpPG1lPZl5EGnjwLhK6N3270/ICDXHsww4wjfFK4tA5tJiOF53SuF8rqzL5Lphyvek1MUWKc2MoyJeBEkoazmAOxNfBpOVjdn9DzbXBB7y2wgtOfv4wnB+cU4r2eP+ClcTP+7WpkZdIi5IaQSm30BqB3bGgMwFa+wIWsXxHDdXrc3dCEeIqid1pAuTNHY7X09z73EplxsIvQAShW1kciOM5EmpCg0L7DxnRhTBoQgzrcJAl32KVA8GF2f6pDAHooB6rL7kv7HlIBwpzBYI/AxYFNNHCgLET3ECuBFJVqGW/JS0SY0jWH8eC8dH1vUnTH0dd4kSG3b2EgEPJQDBtVlVOFgHk1mDtjWY7xoX6A+ssEbr2Zz//08uaiiqLV6gZUNhCAgV7xneSxm8TJhxixgz5rSwvH0cE2fM4QLj3gEkxZ06jekMbWC+7zgAv+7eU3U7nnPYAI2YGdT702w6FfL8x0N0BdcDzKE0342vg+
 tOpoVXFZ
 waosL49n6vqqyDnkbJMErflXRb4rIu3Zfm4SUgeE/q8M6jvthtby5ItMnK4ooKlzfl1XnPpgXgi67WDZ1xuCyaGX/E5HbVW5DdJOemyslKOCbZMpnp4b9Iu7SlNrJXYf0FQMmwIyJuTYHmASzKK0CjYqE6MNbJFrk5WU9fRqHv0aZgXRgzSLGDoBsBkvT93roVZEci/CPdmWyNIMYAqHqCUwrP3ITvQR+Gesh11mSJHEthFx6tof0tgBEUGOuzM4RM6LXXwsZ0AZpHhR8hAPZnMPxmAJkxLhIUcf+eNEpenMGF7ayDNzEymZcdr/LBc1Mdo5dkiliVoZswKNfatXS9BGp9SA8x6qPo3gc8OxclJGtaqt5YcrcYC+3uKqmOLerV4HGq0hNEbXldxv35U/PERT2AE3KNdi8rot+pvu20ITSGnirNyTN+a+RTzvn7+M3zeyHl5/pZFV42LcfEi2aKP6xug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11 2026, David Matlack wrote:

> Add tests to liveupdate.c for the checks done when preserving a tmpfs
> file: A file can be preserved through a read-only fd, but not a
> write-only fd. Preserving it requires permission to write to it, except
> for the owner of an immutable file or of a file on a read-only
> superblock. Append-only files can't be preserved, and files can be
> preserved through a read-only mount. Also check that the size of a
> preserved file is frozen until the file is unpreserved.
>
> These checks don't need a kexec, so they run as part of the regular
> liveupdate selftest.
>
> Enable CONFIG_TMPFS_XATTR for FS_IOC_SETFLAGS. The test cases that use
> it are skipped without it.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/liveupdate/config     |   1 +
>  .../testing/selftests/liveupdate/liveupdate.c | 303 ++++++++++++++++++
>  2 files changed, 304 insertions(+)
>
[...]
> +/*
> + * Test Case: Frozen Size of a Preserved File
> + *
> + * While a file is preserved, its size can't change and no holes can be punched
> + * into it. Writes within the file still work. Closing the session unpreserves
> + * the file, after which its size can change again.
> + */
> +TEST_F(preserve_tmpfs, frozen_size)

Nit: This test isn't really for "frozen size", it makes sure a preserved
file behaves as we expect it to. So perhaps call it "preserved_ops" and
update the comment?

> +{
> +	long page_size = getpagesize();
> +	struct stat st;
> +	char c;
> +	int fd;
> +
> +	fd = create_file("file", 0644);
> +	ASSERT_GE(fd, 0);
> +	ASSERT_EQ(ftruncate(fd, 2 * page_size), 0);
> +	ASSERT_EQ(luo_session_preserve_fd(self->session_fd, fd, 1), 0);
> +
> +	EXPECT_EQ(ftruncate(fd, page_size), -1);
> +	EXPECT_EQ(errno, EPERM);
> +	EXPECT_EQ(ftruncate(fd, 4 * page_size), -1);
> +	EXPECT_EQ(errno, EPERM);
> +	EXPECT_EQ(fallocate(fd, 0, 0, 4 * page_size), -1);
> +	EXPECT_EQ(errno, EPERM);
> +	EXPECT_EQ(fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
> +			    page_size), -1);
> +	EXPECT_EQ(errno, EPERM);
> +	EXPECT_EQ(pwrite(fd, "x", 1, 2 * page_size), -1);
> +	EXPECT_EQ(errno, EPERM);

Nit: Is there any point in matching the exact error code? Wouldn't
checking for a failed syscall be enough?

> +
> +	/* The size didn't change, but writes within the file work. */
> +	ASSERT_EQ(fstat(fd, &st), 0);
> +	EXPECT_EQ(st.st_size, 2 * page_size);
> +	EXPECT_EQ(pwrite(fd, "x", 1, page_size), 1);
> +	EXPECT_EQ(pread(fd, &c, 1, page_size), 1);
> +	EXPECT_EQ(c, 'x');
> +
> +	ASSERT_EQ(close(self->session_fd), 0);
> +	self->session_fd = -1;
> +	EXPECT_EQ(ftruncate(fd, page_size), 0);
> +
> +	close(fd);
> +}
> +
>  TEST_HARNESS_MAIN

-- 
Regards,
Pratyush Yadav

