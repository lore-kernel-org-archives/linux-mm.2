Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D0FC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 23:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5866B008A; Tue, 22 Jul 2025 19:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D9A6B0093; Tue, 22 Jul 2025 19:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBE86B0095; Tue, 22 Jul 2025 19:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B64A6B008A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:42:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB4B91DA818
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:42:27 +0000 (UTC)
X-FDA: 83693527134.09.AE227D3
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id 140161A0006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:42:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xGeZUVXN;
	spf=pass (imf19.hostedemail.com: domain of 34CGAaAYKCG8fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=34CGAaAYKCG8fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753227746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4436MwwaaGsBQYuGwPP46zP65nxhOyA9XxeTVRWwmU=;
	b=5GJC9yyAyrGstGXUC96wmWWSN7QAy3bJ+T9YEFDOaT8KWS0HhV07H5/mCAroIYX9ziu5mQ
	fBC/tuOResO+ekHD9BFtwKG7uxaiVvcm+8SKEPrnkXs+zUqVxr1AypPtPJ4fkINPl7KmQt
	TalWK3Y0m1xLxk2U24QeEQ5nreCe3HI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753227746; a=rsa-sha256;
	cv=none;
	b=PScarIODDEs1vU8eeAtwscsJ2+Wx/QfwDFAupq588hJtTroc91H+JuqKZYRD7tZ35iLLKx
	0QTW68/E2FRYQM6BWXQi5n5vWNAzBLVJ/8tU9R+g+HJ/iiqbfwiaw5TvjPsMSdQtWiy1Tu
	rcem2P4XP00VVaPTAc8gZUHZY1eB+uA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xGeZUVXN;
	spf=pass (imf19.hostedemail.com: domain of 34CGAaAYKCG8fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=34CGAaAYKCG8fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b321087b1cdso6917374a12.2
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753227745; x=1753832545; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C4436MwwaaGsBQYuGwPP46zP65nxhOyA9XxeTVRWwmU=;
        b=xGeZUVXNUiBj8Eqoz179IqbjndwFGXR0Hhecbpp/3nW0lQOztGS5I9admKyM53+xCV
         aFXJ7r1/rFS815Kbksz2yFtEAIni8UjeyA0kiz0boxOQwwGPDFgFuujWilWbC11SONpm
         3/N7AsawA5KlU6iYOcHQIJlF6mdUgVUvxn5d8VoD57NXe4h25G1/K34JyJLV5nk1xSNW
         KBhdOBWoIL/lbOGG2vRbk9hStxYF0NX/5A1pmuX0UTPG28+lKrVzJcI+S2QwMoO5nRU9
         ikv2csKmazoRBR+Chphn2r858TlS0WR6oKkWnjLw9h6LnmrDYJvoPhKfQqsEIXWDfaIt
         6isw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753227745; x=1753832545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C4436MwwaaGsBQYuGwPP46zP65nxhOyA9XxeTVRWwmU=;
        b=qHTXUemHC3lAKIaVJtlmcUdc2XYYyNutPOE1TcDJFfpsKd/yLzyfs3UFUVlBPi8XAg
         zwFKIUtmnHK5if9sHepL/lnnJiCo2IHcprVhs2c462iBt3r4vJ2EnZF4/wSfdowPZy09
         Ttzx+gTg6x9/I3MW89pGVQ7b3rFWQRLs3yR0U0h1I987oAOg+wX7zhg57UCRS0f1AYU9
         +qoUwMXIlT1ylCT5RV6pXnX67UmPovJVu9jXIh+nqe8lY2UM0sYkNukKU4cRC7SmHr70
         QHht9PnU+unayyPMz2o+q6bkFJsSrxie31h3Dp1N5NbifoN2osALi3pBWeY0mkFtr2lg
         eT2A==
X-Forwarded-Encrypted: i=1; AJvYcCWL9bn83P93w+p/2GxKuWUHyQBWMgOxNAZ3VGlaaEHvAEzlFiJUNflvtzCdm4nTx3z3f8GqbnY3rQ==@kvack.org
X-Gm-Message-State: AOJu0Ywl31SInFw1QlkiP/8Zq+tdlBIg4x3531BrgF1u0dAjDdnsWqrG
	JST7pFUYsdU6TrfZfpdVRviISgDSKl2EQ1ysDivHLO/vmp6Jq1gxN0d5jCpqbLlD++AENzZ7+rG
	6lQd+xw==
X-Google-Smtp-Source: AGHT+IHLrCrcEJh1eqR+2A2CsgZBx82DgvNUPV5JtUfEsyEi8WO/Hm3qnM3XnGuN+OWhk9ivI2YtpAQwcFU=
X-Received: from plbjx8.prod.google.com ([2002:a17:903:1388:b0:234:c2e4:1e08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf09:b0:235:ecf2:393
 with SMTP id d9443c01a7336-23f981de13dmr10817305ad.53.1753227744705; Tue, 22
 Jul 2025 16:42:24 -0700 (PDT)
Date: Tue, 22 Jul 2025 16:42:23 -0700
In-Reply-To: <CA+EHjTw46a+NCcgGXQ1HA+a3MSZD9Q97V8W-Xj5+pYuTh4Z2_w@mail.gmail.com>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com> <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
 <aH-1JeJH2cEvyEei@google.com> <CA+EHjTw46a+NCcgGXQ1HA+a3MSZD9Q97V8W-Xj5+pYuTh4Z2_w@mail.gmail.com>
Message-ID: <aIAh3xkU52Z100xK@google.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 140161A0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: cjpon8i41z3ppseyi8tawz1hphx9wny8
X-HE-Tag: 1753227745-966725
X-HE-Meta: U2FsdGVkX1/JHqJhZ+kyLb3VqPLmpxUxBUlmFmnmmeSeRNXKR9Or7bF4v8hI+czk87HB+tq+OpiiuSM5DILp4QJlKf2EcCeCP72TEv8A5lpPC/xbcz7lUxoHiqo/phLduJaEFs5xQgG4fS68cGP/nadDFsTCcF9nZnCC2NdfDupZnSs5JFxvwV6p0cFntUQ8JMOfB9YlPVjfGAGkDqiMBuP/Ky8fL+8VrQwUvtxamfF/wI756w/ajMK4yItPbRtjLyllXls8f5lYHmNlQ/BK8zroGG6PZyOgn4Pd17L3QroHs5b8ac03tL4hVUE4/wN7Q2z7ZvbzYlRqnfCJgjtVGHVoqpL/2RLfMohkB4N21Q1QLL5jN9RsL6Py4h8piCvR9QzQgSUfSZ9uSiYDm9P+W4S6MhL4fJXmoZEKiqq1WWU0EEFCHCDbE8eumCEFPomCcwZZczCK5L9nZE86v3d93iVrnEWu4ka2D5+B+jQ9ok8F7jmS03DtOO2VPkjs+OSZSVjauMcm66rqw8kWenPrz9nWCfYu7h/cEpJhCJVI3ILReXLBeaCKb4k0urjWXFO1B5KND5VHfbAo5DkgcANGfn+D9LOd2fVhNgEfrtOYFlsGTTwwgfJfxVH5E4eGJTPt4U9wbKXqMLmSjhX1O3nISerOpNTD6XGx4Evp4Quiebtym5hnbNQLXqjh9CQuSvPHC13lGcdMsmrSD0H5OcUMiW+nmnAZ2DMTjDhbcc4hzp0SDGa6YYidsAQwV7+1Ugn95F+y0FEnaoCkdQGI/8DKUeIoaAiU5s1qfHFSM3gisCNVjzGI3G/l/GkPL+GVvMyBe7zRng2GELMBILmwvODJgEw4ALFt3JSFZUkQi3r3lTY8QqZHT8DG2yeOrzYz8Gxhf3MX4czXR9uV9c0hbwbDpNGtj0upjaBOu1IdPGPQAaJGo+9AQUS3612qWXSDNpoliIPuIQmfr5JkDeDuWvb
 TYCnMMQX
 b+4CV7zsPigROzvpwHeCsHAnoEj76NwD3zHLmSXRoirJ9hW+E7qJvRjTole0tou9pwpU2q46bt6uBvzJQqJUWtLwj7tlsaRkcqmidRCeSVsgIxURs7tRKWuvHDYnJ5CixEU7GK3QFn+Mvn6yvhpKNEageuRpJmGsZsjo9RR4ktn7QdhMUfTy8+/RUTeYZbIrGTa3jXGWZ+td0T2Z4nY32fenG83YLjbjGGRpUiOlriNJGm3TtARQb737HoRN8t7x7GCXbJueetSGoYxdViUHkyVtaRQqD9dk7fXsqlDwY1Ol2PF6D2cRcNJ2fKIEYZHC6SMoflr2XyYElndRUBN6cENL6Me0pgYghuJiYmKBGZuHI0+vpun6U32eLz5+QVjmbdZq0L/uPFraNdoA6mkJuZDt/Zjd+9ecHxwS3S9jH5/1ZlcCf1khIEYxZr9oTqHAk8EaCXI+9sVe0/xEehpwrjUX2bawDrLdwU/fAar7Pj9tRHu+DuGwXJVPHnyJ0M36f6HAtVD+mpRXtofFF7j0pHx2U5NmoaF7crlBpDfwg6sivmQNzhnLwNBnPcY+HWmxl6IZCCpNZ9F8EHfgVMVCPysvohZ4lxP3TT/Qsk9wRvnG2ArAAnYhwuidV/xmx13Qleec/b2MD6r/R30ZLdEJs+GDc7CPmCEibY50m4EVxhpVm94oBkJynAzyrPe52VVMHMUo16QW0YCmz+0OSR/nA0St018Md4CtwGwfdW5qVxlNFfSA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025, Fuad Tabba wrote:
> On Tue, 22 Jul 2025 at 16:58, Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > > On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > > > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > > > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > > > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > > > > cleaner resting state (see the diff stats).
> > > > >
> > > > > So just so that I am clear, applying the diff below to the appropriate
> > > > > patches would address all the concerns that you have mentioned in this
> > > > > email?
> > > >
> > > > Yes?  It should, I just don't want to pinky swear in case I botched something.
> > >
> > > Other than this patch not applying, nah, I think it's all good ;P. I
> > > guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
> > > somewhere in a local tree of yours. There are quite a few conflicts
> > > and I don't think it would build even if based on the right tree,
> > > e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
> > > rather an addition of an undeclared identifier.
> > >
> > > That said, I think I understand what you mean, and I can apply the
> > > spirit of this patch.
> > >
> > > Stay tuned for v16.
> >
> > Want to point me at your branch?  I can run it through my battery of tests, and
> > maybe save you/us from having to spin a v17.
> 
> That would be great. Here it is:
> 
> https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-basic-6.16-v16
> 
> No known issues from my end. But can you have a look at the patch:
> 
> KVM: guest_memfd: Consolidate Kconfig and guest_memfd enable checks
> 
> In that I collected the changes to the config/enable checks that
> didn't seem to fit well in any of the other patches.

Regarding config stuff, patch 02, KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE, is missing a KVM_GMEM => KVM_GUEST_MEMFD rename.

While playing with this, I also discovered why this code lives in the KVM_X86 config:

  select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM

Commit ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module
is requested") didn't have all the vendor netural configs depend on KVM_X86, and
so it's possible to end up with unmet dependencies.  E.g. KVM_SW_PROTECTED_VM can
be selected with KVM_X86=n, and thus with KVM_GUEST_MEMFD=n.

We could punt on that mess until after this series, but that'd be a even more
churn, and I'm not sure I could stomach giving acks for the continued addition
of ugly kconfig dependencies. :-)

Lastly, regarding "Consolidate Kconfig and guest_memfd enable checks", that needs
to land before f6a5f3a22bbe ("KVM: guest_memfd: Allow host to map guest_memfd pages"),
otherwise KVM will present a weird state where guest_memfd can be used for default
VMs, but if and only KVM_GUEST_MEMFD happens to be selected by something else.
That also provides a better shortlog: "KVM: x86: Enable KVM_GUEST_MEMFD for all
64-bit builds".  The config cleanups and consolidations are a nice side effect,
but what that patch is really doing is enabling KVM_GUEST_MEMFD more broadly.

Actually, all of the arch patches need to come before f6a5f3a22bbe ("KVM: guest_memfd:
Allow host to map guest_memfd pages"), otherwise intermediate builds will have
half-baked support for guest_memfd mmap().  Or rather, KVM shouldn't let userspace
enable GUEST_MEMFD_FLAG_MMAP until all the plumbing is in place.  I suspect that
trying to shuffle the full patches around will create cyclical dependency hell.
It's easy enough to hold off on adding GUEST_MEMFD_FLAG_MMAP until KVM is fully
ready, so I think it makes sense to just add GUEST_MEMFD_FLAG_MMAP along with the
capability.

Rather than trying to pass partial patches around, I pushed a branch to:

  https://github.com/sean-jc/linux.git x86/gmem_mmap

Outside of the x86 config crud, and deferring GUEST_MEMFD_FLAG_MMAP until KVM is
fully prepped, there _shouldn't_ be any changes relatively to what you have.

Note, it's based on:

  https://github.com/kvm-x86/linux.git next

as there are x86 kconfig dependencies/conflicts with changes that are destined
for 6.17 (and I don't think landing this in 6.17 is realistic, i.e. this series
will effectively follow kvm-x86/next no matter what).

I haven't done a ton of runtime testing yet, but it passes all of my build tests
(I have far too many configs), so I'm reasonably confident all the kconfig stuff
isn't horribly broken.

Oh, and I also squashed this into the very last patch.  The curly braces, line
wrap, and hardcoded boolean are all superfluous.

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 4cdccabc160c..a0c5db8fd72d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -249,8 +249,7 @@ static bool check_vm_type(unsigned long vm_type)
        return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
 }
 
-static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
-                          bool expect_mmap_allowed)
+static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags)
 {
        struct kvm_vm *vm;
        size_t total_size;
@@ -272,7 +271,7 @@ static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
 
        test_file_read_write(fd);
 
-       if (expect_mmap_allowed) {
+       if (guest_memfd_flags & GUEST_MEMFD_FLAG_MMAP) {
                test_mmap_supported(fd, page_size, total_size);
                test_fault_overflow(fd, page_size, total_size);
 
@@ -343,13 +342,11 @@ int main(int argc, char *argv[])
 
        test_gmem_flag_validity();
 
-       test_with_type(VM_TYPE_DEFAULT, 0, false);
-       if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP)) {
-               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP,
-                              true);
-       }
+       test_with_type(VM_TYPE_DEFAULT, 0);
+       if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
+               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP);
 
 #ifdef __x86_64__
-       test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
+       test_with_type(KVM_X86_SW_PROTECTED_VM, 0);
 #endif
 }

