Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FA3606A330
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F2ennRW7
Received: by kanga.kvack.org (Postfix)
	id A2EF36B05B6; Sat,  7 Nov 2026 19:44:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF2E6B05B7; Sat,  7 Nov 2026 19:44:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCFC6B05B8; Sat,  7 Nov 2026 19:44:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61D6F6B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CA311603A0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:01 +0000 (UTC)
X-FDA: 85410104682.08.1C8E525
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CBB9840005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2ennRW7;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098639;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcxIV6/PGp7xF0EvDpj0CIJtAjCz1zzihqjKBLCzuh0=;
	b=dzK0UuYkONuFTftxtuuPnfeaZnzj4Osw4XOqDs4C6rY01u0D7WSGlJ9hTHdK3HtiU9Eg8I
	QXsm8jScHN8tP+9EXpsq4RYoAgxCY4vS7rp9SObxvQlI1rrCq35VV8n1TwHb1hiaVAdsWW
	p9nSptnpWRyIB6RN2kI7rxwJryOFEZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098639;
	b=vYp6TFQrBCnB8aGplCCnEZdycXkbOseVfXa1KV/9BPlkHTa5qGfBsHCaPzlHCbSuDrjdb4
	t++7vXn+66wVsrKzOsr2TnJdhTSBZq+H59TxajjZ66+N3uDKHzOAztFGr40aGClePEtLMk
	lbrXv0B4PryGkU2+WJyfGvKE+33C8ng=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2ennRW7;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2306F413BC;
	Sun,  8 Nov 2026 00:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045161F008A6;
	Sun,  8 Nov 2026 00:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098639;
	bh=qcxIV6/PGp7xF0EvDpj0CIJtAjCz1zzihqjKBLCzuh0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F2ennRW710AwaoXCbRe+dVXLP9v2guMCAdBATJ2GQO3zw+0kGG7BeZ4AatOUUx3da
	 oryrJxWcs8PSsoT0xsNGbAFdgClIHtHGWboBseGNlbOyOZnKFDw2RZzRYaAI1efU4H
	 dfJAeFLjn4CRERFZ0M7kKl4V+b2dNpqx9NqTjVimgoaNJvh3ssVUtiqGk9TEH38+0/
	 1xd1kdUjWXtkP64x5SGGS2mSE3SHwes/3rhWRAZWTCgepihrvQ7SQbLo/W6b/1mShh
	 uLCCulnRLFSA8JSo8uGkFVSsgLoQj+c2T/qpjKbJw3V36cSR6c7x39tdKOQzoUV8Vr
	 yWAgnarnyvjkw==
Message-ID: <sashiko-outbox-203422@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 11/88] KVM: selftests: Test rejection of hugepage
 tmpfs mounts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-11-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-11-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:43:57 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CBB9840005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: mgpht9nb37u4e9ns8e69wjwudqzq4smx
X-Rspam-User: 
X-HE-Tag: 1794098639-470018
X-HE-Meta: U2FsdGVkX1/Hy6CSeVih5MXP93808ivSyh4kbupULL+GU+eUPTE9ITzoXROL34cZ2a9MaNLtRE5dujHamf9vUhkekyE1gS+Q0iLL8CE9EOTbCGYvCHYosCtFKQF8oVvY4pfYQQcRfMtPqapuiMm82V5A38UP5F1zLm8Q8j6c67BhL6HHnJyCKi0fLf5uJS8H9fGmWl8jnndLPqQdbJ2SUnrlxxPhkkvsbPfkm7fsLWHI62cu+3oZBljn+8VXRNmY2QuZyuXYyDDi+UbU8Vskv1d8YQParthJFoXexObPaWBVMNKqiLuPXVfYC4ENShoBi6DW6JuHrlWNJysxa6hPoqHCaMDVgZdko+7eZWTTpE6bsBpRSgsWizDC9UoUAVIipQDVVagbT0ueYZ08OGLshazo6Sn09vrJH9aXYbMaU/UCEA07EvmJbAi/qSuqan6Acpy6Ac99NJd/euE+Dmzmy2AwZJiB1yUbRt8g97vWZ1IIdYoyRSABfIKBgd95kXLrqGw1vTomizz/QN/zI+SD5X0+jMdbvF7UGe0cYZaNKdlMhFDZrm/fQcjtSn2DkB1H7cOTbWTyKmT3pN3AjaBhxrAAtpg3u2jMO+biJWC5TBixNbS6vflh3gfTER72RHCSLFwYHL1BRdELFnNs/OXJRXtU9b26g8wHPICKCXMlXhsMn+v6pEruBt/JXcyBhZZzcoZ0tyryYdrHkUyIAyZ++CYm+8twkyUHhLXXyXH2gH2DsUTNHfjcPB7zz6I7w95JKQAIoIwJ8WBgMd/0GIezqVVLrIl0DUaGU34zFUU7Edp0ZYdUZhygheGoEHssZqa7PKApyTJmHTHc7ogjaOeD8YHLRqQfVahSLVBn+hYnFmeNtYBVvO7KQvBsfcpCaCwPHctfF0U4wj4L4zwqDF0qYwyBjF02vPUNfNbhPX5EJ9zHAB2D44vUepDUdcfQBycEozVwWSbj17Cr0/IkdYB
 3QyvMd2F
 sRVcNLnNq6oPzNiXIPWRnjDpKzt+oO4jQI8u37eFyinpv98WfO0a1HD1bmxgTyujpDDn72aRw7KFs8A++a0ECNOptcAO+3a8nzG3oPk3fcgPWrfChk4n0MzzvQcKrLIRTQ4Z6oLES9jOhnbwCqGIMN/1Me1DpxK8Opjxo37KwmT1cAwIoK10N9xB24OSCaikwpFxlwEKgv0leiHcDPjGRxRQGTWF6b15R+xOPTWTnOvL6Woccju54vcrZWU6VZTueZmTt6DOHza6a3ApcISY3cOe1I6D8maHpQ8dbZFeqTNkF7AX9398ISRfDDN1x/xlHECWiWp7ZLoi4FzB5k79dBDTgvZQLIY99TqCWEzFxtr/0QTrQsCZdi8undYcUje7ChBu1hDI9Fl2vq0llDe2s5zze4f7VNHoOiTf19txyjxKproaRbp6fApArHlzMbnVT7TzAxtaZzcoZE9PXcPgIhIsiB5xbWLqaTXsXlc2df7+eDY+Rd9CVw/SdLIJkVojeSAtFncX7MM43VWqtfTx6iNHD46mjAJghhc7fT6ahSErFxC0sr0cPOMxgHhBYP3JOHY5M/auAsoPZhhy/ldbOnh55yMs61MmShUnnZzek01lJSp/izM8AhCytMLSin8wWm1jt7g06IKXc18SY70B40ICClqtjvDqw1776
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: selftests: missing THP check in
  test_resource_fd_tmpfs_huge()
--

commit c298eb47e39bc0e14d17d7c71365382bc9f5859c
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Test rejection of hugepage tmpfs mounts

This commit adds a selftest verifying that guest_memfd creation fails with
-EINVAL when backed by a tmpfs resource pool mounted with huge=3Dalways.

> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testi=
ng/selftests/kvm/guest_memfd_test.c
> index 205f822e10c6c..541d8cdd0bbf7 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -547,6 +547,21 @@ static void test_resource_fd_tmpfs_swap(struct kvm_v=
m *vm)
>  	close(pool_fd);
>  }
> =20
> +static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
> +{
> +	int pool_fd, fd;
> +
> +	pool_fd =3D create_tmpfs_pool_fd("always", true, page_size);

[Severity: Medium]
Should test_resource_fd_tmpfs_huge() check thp_configured() before
configuring a tmpfs mount with huge=3Dalways?

In shmem_parse_one(), setting huge=3Dalways returns -EINVAL when
CONFIG_TRANSPARENT_HUGEPAGE is disabled or has_transparent_hugepage() is
false.  Because create_tmpfs_pool_fd() wraps FSCONFIG_SET_STRING for "huge"
in TEST_ASSERT(), running guest_memfd_test on a system without transparent
hugepages aborts the test suite during setup instead of skipping this
subtest.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D11

