Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF14C83F17
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 17:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997A66B0088; Sat, 26 Jul 2025 13:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948976B0089; Sat, 26 Jul 2025 13:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E566B008A; Sat, 26 Jul 2025 13:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75A026B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:39:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E63BC5C31F
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 17:39:56 +0000 (UTC)
X-FDA: 83707128792.18.7ECF1EB
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2E5DC140002
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 17:39:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="hjB/WQNk";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753551595; a=rsa-sha256;
	cv=none;
	b=tOZxMVzFqUE/PEKCAuklFbT2ViWweciUOj8i7DJBqlEGbn7L1Mmn8agivSRuIR/r73jXTF
	dTgMNoeRYq9DKwDZ1kRdyFU7e3p+BuZGxL6SxWPCY5tyWg04a1+I+0GEjCzMm88DBCX91U
	Ql3rOpTPth97FbWtqksACuhoyDJxw6g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="hjB/WQNk";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753551595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdrE/idYacMbHpoGDSVr5MIJ8gQY0l1UhAmzvFyobwk=;
	b=XXawzU9eaVDTIBqO4OI8Ev5xI399iUM/oS9aOrrWcVZaAJMrL6TM2OVsDAbeNrsb+1ccC6
	6mdaQctJqXe/l5PlM6ftfOilG6jm8UQFq8bIz1bTFVuU79mrB2yOnaHVfnYy1yG5fPHU7d
	oGEtaqkXhpZcHL86e303iNk2KeHQFHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id DDB975C1095;
	Sat, 26 Jul 2025 17:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2C1C4CEED;
	Sat, 26 Jul 2025 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753551593;
	bh=+VDc4EwjT56NL/Zol9kf1Q+HHzms9fp4Pp6RVQi7oDU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hjB/WQNk8i1P2njJC+lf+PTkFsnPl8eL7byz/R7MeXZ5hfwD4iL94Z9W2A7kbF3w5
	 xK9stE0hHsJviTYyeYTpMvEzwPKpYNCrG0yEE0FVS76Y4FMKjVJ8SdtnUJuuTt7uoa
	 pd7UYMQmsr2yWLhrQ3WBsHm32cvuT1vOiRSO7Vn4=
Date: Sat, 26 Jul 2025 10:39:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, Christoph Hellwig <hch@infradead.org>, David
 Hildenbrand <david@redhat.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove io-mapping
Message-Id: <20250726103952.674ee38b16202dff3d54e8aa@linux-foundation.org>
In-Reply-To: <202507261811.4FJjX1bu-lkp@intel.com>
References: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
	<202507261811.4FJjX1bu-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2E5DC140002
X-Stat-Signature: 3eupun9ozbnar9rwkg3egikjwwbpxms7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753551594-691084
X-HE-Meta: U2FsdGVkX1+Nfpcs7b3cO3Y5zOnAqDu1AFSBNk2NT2wgssT93grAYZMnqxC6Hl3vmRT00272smqll7v8wpYCamSuvNigL6YpMEZNtW86cu2COXn/sfw1SWORgPM8WccDSIZszQjMN1snbC9WeeDq2UeV12tAYgvrmkfr76jKyFatcFASe+Acg+KRHUZ+kvZK5XKLj/wyRyy6aKWuHISB3a7S4oP2k0Mz8+OwABf9Urq4LZnkDNk4GlmVGa7AgJaW1KYBxAzDsgnB59sNlj6j9BUrVCGKwlqsBHhv+GF0FAoLaGxOIj3Pje79EMGT4zfWnKy4XQRwolyJr/9iPYMpMJDPgPAVFakXcu/VYdi08kMDAcUJUbY0WjoYGKStjpq8nKkfTgs5T8BTBumKmPRVoBjB+ktkDrOmv8UFZONtEVDM3j/b+kBlOxWKxxcVYiSkTHueNwUFyvtsb71rKM7TyNw/8iqkWBOeoW/AyfUEPiMa+3mA1khMuaRXohty2NIa91QJbqPTABABiMDvihBuPpYCnHM00ZpEWIlPvDMGnozCEGLf5D0Kahx7Lg0gpxRggj3aSkYrj1W7ujRqQuo6by3cQWantbPF+mctdGEljh5ng4baIBVqNnn7baeJWY/bP8PxIu7T8tMCnaTsyuzIRUyQamcRbCkenQnUV0LasmYd/3HwLnea0WfoGegrv24r3Fjs83BmpdN2kd4oKVPyGeiVdJyc6X3YMLBnFTv0LjTtqi2frnXj3YkcPt5SbQ43eImlVqXBxy0DAl7/gB2QkSOpVdolQZpok9q9c7H6iuBAgVaO5y7tOpSIxaXxX3KkT5t8Jzxau3ngzilyQrqVobLGThmfYgY3RiFnLPbrvCkmroa++ImUli9m0WK2dGheV0joNU+hDSdgh//JxmNIvekmgCNgr1l1wrsIfh11zIQhIybaOMcTw20B6PRs3ypTbS+1RlFdxwITGJVU6HW
 1mALDwDq
 oz2j3LTJzS7KTP0wTkgNrC07n4c8gbDvZb/w/l/Ay5xWfUwqx+TMj0FIlxpNY7viBHUwF7Llqty5zENpLiF9/SkU4jzSSVG82yyjpTY3qPctTvxmH6677CQrt62Vo1OSbC/lEeuzdexIW/EcectxNyAfCOFXcMTDHx5i2hY0Ypr1BwWtVHqS98+8Cb9A6Re6cSXWe2+r6+ymBvHScA2+XnUUWITrDND7LnQzJeZ59TiSGcK/cNhUedtCfzRbWsqq3TrzxoXrHzNFgq2ZIqRIWCgxe+xfNsPO5m3GFujhMIOYV3Jfm0OeCiysRTSVgj0JQvxq1e5tQWgFlz96TWhUMGIuwqmZaTcVTJcJHwtkFx5UHKcrfSEmPOD6C2eqHaIkXAUm+bdMzi3J13C0UpHtzxbuYtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 26 Jul 2025 18:15:44 +0800 kernel test robot <lkp@intel.com> wrote:

> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on akpm-mm/mm-everything]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-remove-io-mapping/20250724-225556
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20250724145313.65920-1-lorenzo.stoakes%40oracle.com
> patch subject: [PATCH] mm: remove io-mapping
> config: x86_64-buildonly-randconfig-003-20250725 (https://download.01.org/0day-ci/archive/20250726/202507261811.4FJjX1bu-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250726/202507261811.4FJjX1bu-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202507261811.4FJjX1bu-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/net/ethernet/mellanox/mlx4/main.c:43:10: fatal error: 'linux/io-mapping.h' file not found
>       43 | #include <linux/io-mapping.h>
>          |          ^~~~~~~~~~~~~~~~~~~~

I'm all confused.  include/linux/io-mapping.h is present in every tree
I can find.  This report doesn't identify the HEAD commit which was
used?

