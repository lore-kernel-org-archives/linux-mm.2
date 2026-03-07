Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6F1FC9EF9
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 12:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7CC16B0005; Sat,  7 Mar 2026 07:21:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2AD36B0089; Sat,  7 Mar 2026 07:21:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE196B008A; Sat,  7 Mar 2026 07:21:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A97D16B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 07:21:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A3DDB99A2
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 12:21:20 +0000 (UTC)
X-FDA: 84519177120.09.92C4822
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1AD6A40002
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 12:21:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QyUOkLdH;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772886077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FaW8edQZyxmpceBWYIod6/0bks04qvEO/lACV2gvQOc=;
	b=yTSTJWuW8unvSUzMyFQzcDsP9Zh5P6cZCBgU1jHEBlg8udBmt8ryDZfUEHpe9QcmbIpDY6
	cnpJHIZJEI4hCQi02aMa+VibLtbhmmtnBur4Gqs5bQB+M4h0w98HLgk6ob5k8FYOkvwxBb
	8UD08VOnEhsbjqQyRzuSqUBFL5yryC0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QyUOkLdH;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772886077; a=rsa-sha256;
	cv=none;
	b=BNf2HTIfnLhMF6/MZxh6IxXaUbUdEOxhazf3LG0Il184u7S6xlb4Qd+OMCijBuu1M4mKey
	GSW7aw0zfxlrz/2Iyh33Nc7c4FuEhnrgHsJshYzgY0SoIaBOvyPHoGaVUBvCxIkW4IM0Ay
	PP7Zsw2ILHcgQfikpzeenSlydKj9n0I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772886076; x=1804422076;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=9gQtDxtOnQat+8fcOqzNFtmd1+SU/bLUM1Fd3LNG4SQ=;
  b=QyUOkLdHk01PTI2vMLOBTEeHTzOSaiLHvU1oXoR4rhYt3bzLl+XHimbV
   wCYrBX3GPw9GM3EnsjnttgO/hA4ne78RMGOQOG5vDRQEe1MjdlZQuFYJI
   o9+zvKLtWCXzAY6jGrBTQYS+Q8m7HKIhwPnbU5ce9ta51fi10UPa2GeBW
   obt/8u6+MzIVlpxdQ5e4+OAybo12Izue1FAF1Z/GnA8gDsSv9lqcttpm+
   Ecgof7m9ANg1tguHHhslGxbJyOtcf9qjmLKQL0kdNn84p1ggBGmP1xoD5
   vneWUr5ST6yGkX7T/+jE8YPQGAbAEOiAAk2zdccDWYLGeT6ZmSjjVqFTd
   g==;
X-CSE-ConnectionGUID: 2ZAtGgkxT7+75TWL/JLL8w==
X-CSE-MsgGUID: ck79ZB/3RtKC92evf57NCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="84614110"
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="84614110"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2026 04:21:14 -0800
X-CSE-ConnectionGUID: Qr5fEdROQMipJMVJywo7yA==
X-CSE-MsgGUID: Aga29OiqTWGuCetVEvv/+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="216971844"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 07 Mar 2026 04:21:11 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyqeb-000000001yD-1WmJ;
	Sat, 07 Mar 2026 12:21:09 +0000
Date: Sat, 07 Mar 2026 20:21:02 +0800
From: kernel test robot <lkp@intel.com>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 34/207] fs/binfmt_elf.c:1140:17:
 warning: implicit conversion from 'unsigned long long' to 'unsigned long'
 changes value from 4294967296 to 0
Message-ID: <202603072018.Dl1xONhs-lkp@intel.com>
User-Agent: s-nail v14.9.25
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1AD6A40002
X-Stat-Signature: q9h34hatcixs7ckczkha85sbaot7mnpc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772886075-268109
X-HE-Meta: U2FsdGVkX18y5c5Bipix7W5HtwNhpVifJkI4cusUawbAD2iHa65q2S73VwsDMvK0hXvk+vMpk/F5M47w9wgTax3mfq47+U9JWzA7l4ZpUMIzMn8BfOSS6Gt6Fu7V2aHqdzkqrLl53yYuXiJx6cdaM4/nGydT0yK0kj4EeW4dreFjX9d43zjoELChixB2Q83K0Ywa2Gjzd1zX8SPaXxrN4KEgZ0RXsQzupLMieoe+BBGAvQtx96Zx2SatplvgyiR+kMAIe91J0a5zFTJLFdf0BECZp6DYp7SvVzc6qoNFKKX0gZLvEcnT0Vg8460Y6N0Rodj+ojJ/T/RnLMVeuMWYGx+0TuThe34X9TJ+caT+GurCT7MdCPwR6KNHAf5/hbBSnO2Td2h3HIacPc8/+pSxJqxG7npxi+v4c/baIWO+A8hgWo8K5c5IV/4RLXZfdExPJLJuVwPhnas4GmPmOioELBXTEZsYpI9+A2w3KXsgj1tpMlIYLkSrSWcIkp+M876C6/jfdLerxzjRW3wxg4I66RTeHJHdNxxTTJMq+XrTiSZOFS/CpGcwo4bxry92n3IywkEmxZyB5QJxhMphPXx09k2ktRZlp0N9Nb6AhYubJfODH5F4olnISX8CJze3HCRJe2gkrTc54VnRk93yzTFYF2W4lVeAKdmaMYwh+ZXZaiAoTHTzISZCxudFJAgjZM2gnBLZPWoaDr4Aw+Be50iexEVRWzwix4sj5ycQuLbsIu09lUTAZAvNT03+UQbKLgBnJslQdEy9X+HpeC+i2213Yg+AUboykFp66HRBPxyS4eCKbFGEJI3IGnLsGohfNykiaOzg/35cmjicfLceBbrjchQe1mc39z4pBJdC4EYf/gb/iLLiL3vpoU9SKh5xjyoHH3AFbZaL5GjxnggNBAtqbnzyIgd8P63/QFaeAO8spmgzkkAiW6kFaIDRleTeFDVF9zGmnZ7Ppsyw+gumOjr
 fQdn/bx6
 i1CzCFWhSjzACK2lZTU59JdTrsFYEgQZRuP782zoGmgXhn6pfUDbtYoVYIAsoW6UgU9tiDsJxOQjTO3vnicx4GC7bGGq+vESF3wRrs5EUmTDWkrPCItHKcJh40/WlH5f2vmhqjfrccn7HA7rOQ7huaokzEZi3Fl7LRnpW+BsBpAidstsXLma4plU5OSpLCfhbhw6LG/Y24IHLvyoXH+Hgs/hqY0OYfYZq+qDGevwwDpJyohKTUYNIuk1e78F9IGxx4XvEka1ZQrd2st0xXdDiCEEk6vVkl9yhcU61/DMT2z2pUUu+yWMkYv6Kv09Q3zpXJAuLIrgDRjvFgTzgAJfBbymGcBLgaj19u7bDL8JUH4jMoWy11NeTEefzA1STCfohgIQxunHxLRcDjCk+Dd0x1kPCom03bOZuknFmyNN1n6jIYb1GTW2Nn6T39NRva4x0YR4y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unst=
able
head:   49cb736d092aaa856283e33b78ec3afb3964d82f
commit: cd9119a9480d9d93fdf06792f8f9917cc4f9999c [34/207] mm/userfaultfd: f=
ix hugetlb fault mutex hash calculation
config: powerpc-currituck_defconfig (https://download.01.org/0day-ci/archiv=
e/20260307/202603072018.Dl1xONhs-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project c32=
caeec8158d634bb71ab8911a6031248b9fc47)
reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archive=
/20260307/202603072018.Dl1xONhs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603072018.Dl1xONhs-lkp@i=
ntel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/binfmt_elf.c:31:
   include/linux/hugetlb.h:1214:9: error: call to undeclared function 'line=
ar_page_index'; ISO C99 and later do not support implicit function declarat=
ions [-Wimplicit-function-declaration]
    1214 |         return linear_page_index(vma, address);
         |                ^
   In file included from fs/binfmt_elf.c:32:
   include/linux/pagemap.h:1079:23: error: conflicting types for 'linear_pa=
ge_index'
    1079 | static inline pgoff_t linear_page_index(const struct vm_area_str=
uct *vma,
         |                       ^
   include/linux/hugetlb.h:1214:9: note: previous implicit declaration is h=
ere
    1214 |         return linear_page_index(vma, address);
         |                ^
>> fs/binfmt_elf.c:1140:17: warning: implicit conversion from 'unsigned lon=
g long' to 'unsigned long' changes value from 4294967296 to 0 [-Wconstant-c=
onversion]
    1140 |                                 load_bias =3D ELF_ET_DYN_BASE;
         |                                           ~ ^~~~~~~~~~~~~~~
   arch/powerpc/include/asm/elf.h:28:10: note: expanded from macro 'ELF_ET_=
DYN_BASE'
      28 |                                                    0x100000000UL)
         |                                                    ^~~~~~~~~~~~~
   fs/binfmt_elf.c:1326:13: warning: implicit conversion from 'unsigned lon=
g long' to 'unsigned long' changes value from 4294967296 to 0 [-Wconstant-c=
onversion]
    1326 |                 elf_brk =3D ELF_ET_DYN_BASE;
         |                         ~ ^~~~~~~~~~~~~~~
   arch/powerpc/include/asm/elf.h:28:10: note: expanded from macro 'ELF_ET_=
DYN_BASE'
      28 |                                                    0x100000000UL)
         |                                                    ^~~~~~~~~~~~~
   2 warnings and 2 errors generated.


vim +1140 fs/binfmt_elf.c

00e19ceec80b03a Dave Martin        2020-03-16   831 =20
71613c3b871c5a9 Al Viro            2012-10-20   832  static int load_elf_bi=
nary(struct linux_binprm *bprm)
^1da177e4c3f415 Linus Torvalds     2005-04-16   833  {
^1da177e4c3f415 Linus Torvalds     2005-04-16   834  	struct file *interpre=
ter =3D NULL; /* to shut gcc up */
2b4bfbe0967697c Akira Kawata       2022-01-27   835  	unsigned long load_bi=
as =3D 0, phdr_addr =3D 0;
2b4bfbe0967697c Akira Kawata       2022-01-27   836  	int first_pt_load =3D =
1;
^1da177e4c3f415 Linus Torvalds     2005-04-16   837  	unsigned long error;
a9d9ef133f443ae Paul Burton        2014-09-11   838  	struct elf_phdr *elf_=
ppnt, *elf_phdata, *interp_elf_phdata =3D NULL;
00e19ceec80b03a Dave Martin        2020-03-16   839  	struct elf_phdr *elf_=
property_phdata =3D NULL;
8ed2ef21ff564cf Kees Cook          2023-09-28   840  	unsigned long elf_brk;
11854fe263eb1b9 Kees Cook          2025-04-25   841  	bool brk_moved =3D fa=
lse;
^1da177e4c3f415 Linus Torvalds     2005-04-16   842  	int retval, i;
cc503c1b43e002e Jiri Kosina        2008-01-30   843  	unsigned long elf_ent=
ry;
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30   844  	unsigned long e_entry;
cc503c1b43e002e Jiri Kosina        2008-01-30   845  	unsigned long interp_=
load_addr =3D 0;
^1da177e4c3f415 Linus Torvalds     2005-04-16   846  	unsigned long start_c=
ode, end_code, start_data, end_data;
1a530a6f23f7dca David Daney        2011-03-22   847  	unsigned long reloc_f=
unc_desc __maybe_unused =3D 0;
8de61e69c2feb10 David Rientjes     2006-12-06   848  	int executable_stack =
=3D EXSTACK_DEFAULT;
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30   849  	struct elfhdr *elf_ex=
 =3D (struct elfhdr *)bprm->buf;
0693ffebcfe5ac7 Alexey Dobriyan    2020-04-06   850  	struct elfhdr *interp=
_elf_ex =3D NULL;
774c105ed8d791b Paul Burton        2014-09-11   851  	struct arch_elf_state=
 arch_state =3D INIT_ARCH_ELF_STATE;
03c6d723eeac2d7 Alexey Dobriyan    2020-01-30   852  	struct mm_struct *mm;
249b08e4e504d4c Alexey Dobriyan    2019-05-14   853  	struct pt_regs *regs;
^1da177e4c3f415 Linus Torvalds     2005-04-16   854 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16   855  	retval =3D -ENOEXEC;
^1da177e4c3f415 Linus Torvalds     2005-04-16   856  	/* First of all, some=
 simple consistency checks */
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30   857  	if (memcmp(elf_ex->e_=
ident, ELFMAG, SELFMAG) !=3D 0)
^1da177e4c3f415 Linus Torvalds     2005-04-16   858  		goto out;
^1da177e4c3f415 Linus Torvalds     2005-04-16   859 =20
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30   860  	if (elf_ex->e_type !=
=3D ET_EXEC && elf_ex->e_type !=3D ET_DYN)
^1da177e4c3f415 Linus Torvalds     2005-04-16   861  		goto out;
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30   862  	if (!elf_check_arch(e=
lf_ex))
^1da177e4c3f415 Linus Torvalds     2005-04-16   863  		goto out;
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30   864  	if (elf_check_fdpic(e=
lf_ex))
4755200b6b116db Nicolas Pitre      2017-08-16   865  		goto out;
b013ed403197f3f Lorenzo Stoakes    2025-06-16   866  	if (!can_mmap_file(bp=
rm->file))
^1da177e4c3f415 Linus Torvalds     2005-04-16   867  		goto out;
^1da177e4c3f415 Linus Torvalds     2005-04-16   868 =20
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30   869  	elf_phdata =3D load_e=
lf_phdrs(elf_ex, bprm->file);
^1da177e4c3f415 Linus Torvalds     2005-04-16   870  	if (!elf_phdata)
^1da177e4c3f415 Linus Torvalds     2005-04-16   871  		goto out;
^1da177e4c3f415 Linus Torvalds     2005-04-16   872 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16   873  	elf_ppnt =3D elf_phda=
ta;
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30   874  	for (i =3D 0; i < elf=
_ex->e_phnum; i++, elf_ppnt++) {
cc338010a233c08 Alexey Dobriyan    2019-05-14   875  		char *elf_interprete=
r;
5cf4a36382588e6 Alexey Dobriyan    2019-05-14   876 =20
00e19ceec80b03a Dave Martin        2020-03-16   877  		if (elf_ppnt->p_type=
 =3D=3D PT_GNU_PROPERTY) {
00e19ceec80b03a Dave Martin        2020-03-16   878  			elf_property_phdata=
 =3D elf_ppnt;
00e19ceec80b03a Dave Martin        2020-03-16   879  			continue;
00e19ceec80b03a Dave Martin        2020-03-16   880  		}
00e19ceec80b03a Dave Martin        2020-03-16   881 =20
be0deb585e4c51d Alexey Dobriyan    2019-05-14   882  		if (elf_ppnt->p_type=
 !=3D PT_INTERP)
be0deb585e4c51d Alexey Dobriyan    2019-05-14   883  			continue;
be0deb585e4c51d Alexey Dobriyan    2019-05-14   884 =20
be0deb585e4c51d Alexey Dobriyan    2019-05-14   885  		/*
be0deb585e4c51d Alexey Dobriyan    2019-05-14   886  		 * This is the progr=
am interpreter used for shared libraries -
be0deb585e4c51d Alexey Dobriyan    2019-05-14   887  		 * for now assume th=
at this is an a.out format binary.
^1da177e4c3f415 Linus Torvalds     2005-04-16   888  		 */
^1da177e4c3f415 Linus Torvalds     2005-04-16   889  		retval =3D -ENOEXEC;
be0deb585e4c51d Alexey Dobriyan    2019-05-14   890  		if (elf_ppnt->p_file=
sz > PATH_MAX || elf_ppnt->p_filesz < 2)
e7b9b550f53e81e Al Viro            2009-03-29   891  			goto out_free_ph;
^1da177e4c3f415 Linus Torvalds     2005-04-16   892 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16   893  		retval =3D -ENOMEM;
be0deb585e4c51d Alexey Dobriyan    2019-05-14   894  		elf_interpreter =3D =
kmalloc(elf_ppnt->p_filesz, GFP_KERNEL);
^1da177e4c3f415 Linus Torvalds     2005-04-16   895  		if (!elf_interpreter)
e7b9b550f53e81e Al Viro            2009-03-29   896  			goto out_free_ph;
^1da177e4c3f415 Linus Torvalds     2005-04-16   897 =20
658c03356511854 Alexey Dobriyan    2019-12-04   898  		retval =3D elf_read(=
bprm->file, elf_interpreter, elf_ppnt->p_filesz,
658c03356511854 Alexey Dobriyan    2019-12-04   899  				  elf_ppnt->p_offs=
et);
658c03356511854 Alexey Dobriyan    2019-12-04   900  		if (retval < 0)
^1da177e4c3f415 Linus Torvalds     2005-04-16   901  			goto out_free_inter=
p;
^1da177e4c3f415 Linus Torvalds     2005-04-16   902  		/* make sure path is=
 NULL terminated */
^1da177e4c3f415 Linus Torvalds     2005-04-16   903  		retval =3D -ENOEXEC;
^1da177e4c3f415 Linus Torvalds     2005-04-16   904  		if (elf_interpreter[=
elf_ppnt->p_filesz - 1] !=3D '\0')
^1da177e4c3f415 Linus Torvalds     2005-04-16   905  			goto out_free_inter=
p;
^1da177e4c3f415 Linus Torvalds     2005-04-16   906 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16   907  		interpreter =3D open=
_exec(elf_interpreter);
cc338010a233c08 Alexey Dobriyan    2019-05-14   908  		kfree(elf_interprete=
r);
^1da177e4c3f415 Linus Torvalds     2005-04-16   909  		retval =3D PTR_ERR(i=
nterpreter);
^1da177e4c3f415 Linus Torvalds     2005-04-16   910  		if (IS_ERR(interpret=
er))
cc338010a233c08 Alexey Dobriyan    2019-05-14   911  			goto out_free_ph;
1fb844961818ce9 Alexey Dobriyan    2007-01-26   912 =20
1fb844961818ce9 Alexey Dobriyan    2007-01-26   913  		/*
be0deb585e4c51d Alexey Dobriyan    2019-05-14   914  		 * If the binary is =
not readable then enforce mm->dumpable =3D 0
be0deb585e4c51d Alexey Dobriyan    2019-05-14   915  		 * regardless of the=
 interpreter's permissions.
1fb844961818ce9 Alexey Dobriyan    2007-01-26   916  		 */
1b5d783c94c328d Al Viro            2011-06-19   917  		would_dump(bprm, int=
erpreter);
1fb844961818ce9 Alexey Dobriyan    2007-01-26   918 =20
bf4afc53b77aeaa Linus Torvalds     2026-02-21   919  		interp_elf_ex =3D km=
alloc_obj(*interp_elf_ex);
0693ffebcfe5ac7 Alexey Dobriyan    2020-04-06   920  		if (!interp_elf_ex) {
0693ffebcfe5ac7 Alexey Dobriyan    2020-04-06   921  			retval =3D -ENOMEM;
594d2a14f2168c0 Li Zetao           2022-10-24   922  			goto out_free_file;
0693ffebcfe5ac7 Alexey Dobriyan    2020-04-06   923  		}
0693ffebcfe5ac7 Alexey Dobriyan    2020-04-06   924 =20
b582ef5c53040c5 Maciej W. Rozycki  2015-10-26   925  		/* Get the exec head=
ers */
c69bcc932ef3568 Alexey Dobriyan    2020-04-06   926  		retval =3D elf_read(=
interpreter, interp_elf_ex,
c69bcc932ef3568 Alexey Dobriyan    2020-04-06   927  				  sizeof(*interp_e=
lf_ex), 0);
658c03356511854 Alexey Dobriyan    2019-12-04   928  		if (retval < 0)
^1da177e4c3f415 Linus Torvalds     2005-04-16   929  			goto out_free_dentr=
y;
^1da177e4c3f415 Linus Torvalds     2005-04-16   930 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16   931  		break;
cc338010a233c08 Alexey Dobriyan    2019-05-14   932 =20
cc338010a233c08 Alexey Dobriyan    2019-05-14   933  out_free_interp:
cc338010a233c08 Alexey Dobriyan    2019-05-14   934  		kfree(elf_interprete=
r);
cc338010a233c08 Alexey Dobriyan    2019-05-14   935  		goto out_free_ph;
^1da177e4c3f415 Linus Torvalds     2005-04-16   936  	}
^1da177e4c3f415 Linus Torvalds     2005-04-16   937 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16   938  	elf_ppnt =3D elf_phda=
ta;
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30   939  	for (i =3D 0; i < elf=
_ex->e_phnum; i++, elf_ppnt++)
774c105ed8d791b Paul Burton        2014-09-11   940  		switch (elf_ppnt->p_=
type) {
774c105ed8d791b Paul Burton        2014-09-11   941  		case PT_GNU_STACK:
^1da177e4c3f415 Linus Torvalds     2005-04-16   942  			if (elf_ppnt->p_fla=
gs & PF_X)
^1da177e4c3f415 Linus Torvalds     2005-04-16   943  				executable_stack =
=3D EXSTACK_ENABLE_X;
^1da177e4c3f415 Linus Torvalds     2005-04-16   944  			else
^1da177e4c3f415 Linus Torvalds     2005-04-16   945  				executable_stack =
=3D EXSTACK_DISABLE_X;
^1da177e4c3f415 Linus Torvalds     2005-04-16   946  			break;
774c105ed8d791b Paul Burton        2014-09-11   947 =20
774c105ed8d791b Paul Burton        2014-09-11   948  		case PT_LOPROC ... P=
T_HIPROC:
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30   949  			retval =3D arch_elf=
_pt_proc(elf_ex, elf_ppnt,
774c105ed8d791b Paul Burton        2014-09-11   950  						  bprm->file, fa=
lse,
774c105ed8d791b Paul Burton        2014-09-11   951  						  &arch_state);
774c105ed8d791b Paul Burton        2014-09-11   952  			if (retval)
774c105ed8d791b Paul Burton        2014-09-11   953  				goto out_free_dent=
ry;
774c105ed8d791b Paul Burton        2014-09-11   954  			break;
^1da177e4c3f415 Linus Torvalds     2005-04-16   955  		}
^1da177e4c3f415 Linus Torvalds     2005-04-16   956 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16   957  	/* Some simple consis=
tency checks for the interpreter */
cc338010a233c08 Alexey Dobriyan    2019-05-14   958  	if (interpreter) {
^1da177e4c3f415 Linus Torvalds     2005-04-16   959  		retval =3D -ELIBBAD;
d20894a23708c2a Andi Kleen         2008-02-08   960  		/* Not an ELF interp=
reter */
c69bcc932ef3568 Alexey Dobriyan    2020-04-06   961  		if (memcmp(interp_el=
f_ex->e_ident, ELFMAG, SELFMAG) !=3D 0)
^1da177e4c3f415 Linus Torvalds     2005-04-16   962  			goto out_free_dentr=
y;
^1da177e4c3f415 Linus Torvalds     2005-04-16   963  		/* Verify the interp=
reter has a valid arch */
c69bcc932ef3568 Alexey Dobriyan    2020-04-06   964  		if (!elf_check_arch(=
interp_elf_ex) ||
c69bcc932ef3568 Alexey Dobriyan    2020-04-06   965  		    elf_check_fdpic(=
interp_elf_ex))
^1da177e4c3f415 Linus Torvalds     2005-04-16   966  			goto out_free_dentr=
y;
a9d9ef133f443ae Paul Burton        2014-09-11   967 =20
a9d9ef133f443ae Paul Burton        2014-09-11   968  		/* Load the interpre=
ter program headers */
c69bcc932ef3568 Alexey Dobriyan    2020-04-06   969  		interp_elf_phdata =
=3D load_elf_phdrs(interp_elf_ex,
a9d9ef133f443ae Paul Burton        2014-09-11   970  						   interpreter);
a9d9ef133f443ae Paul Burton        2014-09-11   971  		if (!interp_elf_phda=
ta)
a9d9ef133f443ae Paul Burton        2014-09-11   972  			goto out_free_dentr=
y;
774c105ed8d791b Paul Burton        2014-09-11   973 =20
774c105ed8d791b Paul Burton        2014-09-11   974  		/* Pass PT_LOPROC..P=
T_HIPROC headers to arch code */
00e19ceec80b03a Dave Martin        2020-03-16   975  		elf_property_phdata =
=3D NULL;
774c105ed8d791b Paul Burton        2014-09-11   976  		elf_ppnt =3D interp_=
elf_phdata;
c69bcc932ef3568 Alexey Dobriyan    2020-04-06   977  		for (i =3D 0; i < in=
terp_elf_ex->e_phnum; i++, elf_ppnt++)
774c105ed8d791b Paul Burton        2014-09-11   978  			switch (elf_ppnt->p=
_type) {
00e19ceec80b03a Dave Martin        2020-03-16   979  			case PT_GNU_PROPERT=
Y:
00e19ceec80b03a Dave Martin        2020-03-16   980  				elf_property_phdat=
a =3D elf_ppnt;
00e19ceec80b03a Dave Martin        2020-03-16   981  				break;
00e19ceec80b03a Dave Martin        2020-03-16   982 =20
774c105ed8d791b Paul Burton        2014-09-11   983  			case PT_LOPROC ... =
PT_HIPROC:
c69bcc932ef3568 Alexey Dobriyan    2020-04-06   984  				retval =3D arch_el=
f_pt_proc(interp_elf_ex,
774c105ed8d791b Paul Burton        2014-09-11   985  							  elf_ppnt, int=
erpreter,
774c105ed8d791b Paul Burton        2014-09-11   986  							  true, &arch_s=
tate);
774c105ed8d791b Paul Burton        2014-09-11   987  				if (retval)
774c105ed8d791b Paul Burton        2014-09-11   988  					goto out_free_den=
try;
774c105ed8d791b Paul Burton        2014-09-11   989  				break;
^1da177e4c3f415 Linus Torvalds     2005-04-16   990  			}
774c105ed8d791b Paul Burton        2014-09-11   991  	}
774c105ed8d791b Paul Burton        2014-09-11   992 =20
00e19ceec80b03a Dave Martin        2020-03-16   993  	retval =3D parse_elf_=
properties(interpreter ?: bprm->file,
00e19ceec80b03a Dave Martin        2020-03-16   994  				      elf_property=
_phdata, &arch_state);
00e19ceec80b03a Dave Martin        2020-03-16   995  	if (retval)
00e19ceec80b03a Dave Martin        2020-03-16   996  		goto out_free_dentry;
00e19ceec80b03a Dave Martin        2020-03-16   997 =20
774c105ed8d791b Paul Burton        2014-09-11   998  	/*
774c105ed8d791b Paul Burton        2014-09-11   999  	 * Allow arch code to=
 reject the ELF at this point, whilst it's
774c105ed8d791b Paul Burton        2014-09-11  1000  	 * still possible to =
return an error to the code that invoked
774c105ed8d791b Paul Burton        2014-09-11  1001  	 * the exec syscall.
774c105ed8d791b Paul Burton        2014-09-11  1002  	 */
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30  1003  	retval =3D arch_check=
_elf(elf_ex,
c69bcc932ef3568 Alexey Dobriyan    2020-04-06  1004  				!!interpreter, int=
erp_elf_ex,
eb4bc076ff94b82 Maciej W. Rozycki  2015-11-13  1005  				&arch_state);
774c105ed8d791b Paul Burton        2014-09-11  1006  	if (retval)
774c105ed8d791b Paul Burton        2014-09-11  1007  		goto out_free_dentry;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1008 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1009  	/* Flush all traces o=
f the currently running executable */
2388777a0a5957a Eric W. Biederman  2020-05-03  1010  	retval =3D begin_new_=
exec(bprm);
^1da177e4c3f415 Linus Torvalds     2005-04-16  1011  	if (retval)
^1da177e4c3f415 Linus Torvalds     2005-04-16  1012  		goto out_free_dentry;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1013 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1014  	/* Do this immediatel=
y, since STACK_TOP as used in setup_arg_pages
^1da177e4c3f415 Linus Torvalds     2005-04-16  1015  	   may depend on the =
personality.  */
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30  1016  	SET_PERSONALITY2(*elf=
_ex, &arch_state);
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30  1017  	if (elf_read_implies_=
exec(*elf_ex, executable_stack))
^1da177e4c3f415 Linus Torvalds     2005-04-16  1018  		current->personality=
 |=3D READ_IMPLIES_EXEC;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1019 =20
2a97388a807b6ab Alexey Dobriyan    2024-06-21  1020  	const int snapshot_ra=
ndomize_va_space =3D READ_ONCE(randomize_va_space);
2a97388a807b6ab Alexey Dobriyan    2024-06-21  1021  	if (!(current->person=
ality & ADDR_NO_RANDOMIZE) && snapshot_randomize_va_space)
^1da177e4c3f415 Linus Torvalds     2005-04-16  1022  		current->flags |=3D =
PF_RANDOMIZE;
221af7f87b97431 Linus Torvalds     2010-01-28  1023 =20
221af7f87b97431 Linus Torvalds     2010-01-28  1024  	setup_new_exec(bprm);
^1da177e4c3f415 Linus Torvalds     2005-04-16  1025 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1026  	/* Do this so that we=
 can load the interpreter, if need be.  We will
^1da177e4c3f415 Linus Torvalds     2005-04-16  1027  	   change some of the=
se later */
^1da177e4c3f415 Linus Torvalds     2005-04-16  1028  	retval =3D setup_arg_=
pages(bprm, randomize_stack_top(STACK_TOP),
^1da177e4c3f415 Linus Torvalds     2005-04-16  1029  				 executable_stack);
19d860a140beac4 Al Viro            2014-05-04  1030  	if (retval < 0)
^1da177e4c3f415 Linus Torvalds     2005-04-16  1031  		goto out_free_dentry;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1032 =20
852643165aea099 Alexey Dobriyan    2019-05-14  1033  	elf_brk =3D 0;
852643165aea099 Alexey Dobriyan    2019-05-14  1034 =20
852643165aea099 Alexey Dobriyan    2019-05-14  1035  	start_code =3D ~0UL;
852643165aea099 Alexey Dobriyan    2019-05-14  1036  	end_code =3D 0;
852643165aea099 Alexey Dobriyan    2019-05-14  1037  	start_data =3D 0;
852643165aea099 Alexey Dobriyan    2019-05-14  1038  	end_data =3D 0;
852643165aea099 Alexey Dobriyan    2019-05-14  1039 =20
af901ca181d92aa Andr=C3=A9 Goddard Rosa 2009-11-14  1040  	/* Now we do a l=
ittle grungy work by mmapping the ELF image into
cc503c1b43e002e Jiri Kosina        2008-01-30  1041  	   the correct locati=
on in memory. */
f4e5cc2c44bf760 Jesper Juhl        2006-06-23  1042  	for(i =3D 0, elf_ppnt=
 =3D elf_phdata;
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30  1043  	    i < elf_ex->e_phn=
um; i++, elf_ppnt++) {
b212921b13bda08 Linus Torvalds     2019-10-06  1044  		int elf_prot, elf_fl=
ags;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1045  		unsigned long k, vad=
dr;
a87938b2e246b81 Michael Davidson   2015-04-14  1046  		unsigned long total_=
size =3D 0;
ce81bb256a22425 Chris Kennelly     2020-10-15  1047  		unsigned long alignm=
ent;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1048 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1049  		if (elf_ppnt->p_type=
 !=3D PT_LOAD)
^1da177e4c3f415 Linus Torvalds     2005-04-16  1050  			continue;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1051 =20
fe0f67660ee9c99 Dave Martin        2020-03-16  1052  		elf_prot =3D make_pr=
ot(elf_ppnt->p_flags, &arch_state,
fe0f67660ee9c99 Dave Martin        2020-03-16  1053  				     !!interpreter=
, false);
^1da177e4c3f415 Linus Torvalds     2005-04-16  1054 =20
4589ff7ca815163 David Hildenbrand  2021-04-23  1055  		elf_flags =3D MAP_PR=
IVATE;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1056 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1057  		vaddr =3D elf_ppnt->=
p_vaddr;
eab09532d400906 Kees Cook          2017-07-10  1058  		/*
2b4bfbe0967697c Akira Kawata       2022-01-27  1059  		 * The first time th=
rough the loop, first_pt_load is true:
5f501d555653f89 Kees Cook          2021-11-08  1060  		 * layout will be ca=
lculated. Once set, use MAP_FIXED since
5f501d555653f89 Kees Cook          2021-11-08  1061  		 * we know we've alr=
eady safely mapped the entire region with
5f501d555653f89 Kees Cook          2021-11-08  1062  		 * MAP_FIXED_NOREPLA=
CE in the once-per-binary logic following.
eab09532d400906 Kees Cook          2017-07-10  1063  		 */
2b4bfbe0967697c Akira Kawata       2022-01-27  1064  		if (!first_pt_load) {
b212921b13bda08 Linus Torvalds     2019-10-06  1065  			elf_flags |=3D MAP_=
FIXED;
5f501d555653f89 Kees Cook          2021-11-08  1066  		} else if (elf_ex->e=
_type =3D=3D ET_EXEC) {
5f501d555653f89 Kees Cook          2021-11-08  1067  			/*
5f501d555653f89 Kees Cook          2021-11-08  1068  			 * This logic is ru=
n once for the first LOAD Program
5f501d555653f89 Kees Cook          2021-11-08  1069  			 * Header for ET_EX=
EC binaries. No special handling
5f501d555653f89 Kees Cook          2021-11-08  1070  			 * is needed.
5f501d555653f89 Kees Cook          2021-11-08  1071  			 */
5f501d555653f89 Kees Cook          2021-11-08  1072  			elf_flags |=3D MAP_=
FIXED_NOREPLACE;
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30  1073  		} else if (elf_ex->e=
_type =3D=3D ET_DYN) {
eab09532d400906 Kees Cook          2017-07-10  1074  			/*
eab09532d400906 Kees Cook          2017-07-10  1075  			 * This logic is ru=
n once for the first LOAD Program
eab09532d400906 Kees Cook          2017-07-10  1076  			 * Header for ET_DY=
N binaries to calculate the
eab09532d400906 Kees Cook          2017-07-10  1077  			 * randomization (l=
oad_bias) for all the LOAD
5f501d555653f89 Kees Cook          2021-11-08  1078  			 * Program Headers.
2d4cf7b190bbfad Kees Cook          2024-05-08  1079  			 */
2d4cf7b190bbfad Kees Cook          2024-05-08  1080 =20
2d4cf7b190bbfad Kees Cook          2024-05-08  1081  			/*
2d4cf7b190bbfad Kees Cook          2024-05-08  1082  			 * Calculate the en=
tire size of the ELF mapping
2d4cf7b190bbfad Kees Cook          2024-05-08  1083  			 * (total_size), us=
ed for the initial mapping,
2d4cf7b190bbfad Kees Cook          2024-05-08  1084  			 * due to load_addr=
_set which is set to true later
2d4cf7b190bbfad Kees Cook          2024-05-08  1085  			 * once the initial=
 mapping is performed.
eab09532d400906 Kees Cook          2017-07-10  1086  			 *
2d4cf7b190bbfad Kees Cook          2024-05-08  1087  			 * Note that this i=
s only sensible when the LOAD
2d4cf7b190bbfad Kees Cook          2024-05-08  1088  			 * segments are con=
tiguous (or overlapping). If
2d4cf7b190bbfad Kees Cook          2024-05-08  1089  			 * used for LOADs t=
hat are far apart, this would
2d4cf7b190bbfad Kees Cook          2024-05-08  1090  			 * cause the holes =
between LOADs to be mapped,
2d4cf7b190bbfad Kees Cook          2024-05-08  1091  			 * running the risk=
 of having the mapping fail,
2d4cf7b190bbfad Kees Cook          2024-05-08  1092  			 * as it would be l=
arger than the ELF file itself.
eab09532d400906 Kees Cook          2017-07-10  1093  			 *
2d4cf7b190bbfad Kees Cook          2024-05-08  1094  			 * As a result, onl=
y ET_DYN does this, since
2d4cf7b190bbfad Kees Cook          2024-05-08  1095  			 * some ET_EXEC (e.=
g. ia64) may have large virtual
2d4cf7b190bbfad Kees Cook          2024-05-08  1096  			 * memory holes bet=
ween LOADs.
2d4cf7b190bbfad Kees Cook          2024-05-08  1097  			 *
2d4cf7b190bbfad Kees Cook          2024-05-08  1098  			 */
2d4cf7b190bbfad Kees Cook          2024-05-08  1099  			total_size =3D tota=
l_mapping_size(elf_phdata,
2d4cf7b190bbfad Kees Cook          2024-05-08  1100  							elf_ex->e_phnum=
);
2d4cf7b190bbfad Kees Cook          2024-05-08  1101  			if (!total_size) {
2d4cf7b190bbfad Kees Cook          2024-05-08  1102  				retval =3D -EINVAL;
2d4cf7b190bbfad Kees Cook          2024-05-08  1103  				goto out_free_dent=
ry;
2d4cf7b190bbfad Kees Cook          2024-05-08  1104  			}
2d4cf7b190bbfad Kees Cook          2024-05-08  1105 =20
3545deff0ec7a37 Kees Cook          2024-05-08  1106  			/* Calculate any re=
quested alignment. */
3545deff0ec7a37 Kees Cook          2024-05-08  1107  			alignment =3D maxim=
um_alignment(elf_phdata, elf_ex->e_phnum);
3545deff0ec7a37 Kees Cook          2024-05-08  1108 =20
11854fe263eb1b9 Kees Cook          2025-04-25  1109  			/**
11854fe263eb1b9 Kees Cook          2025-04-25  1110  			 * DOC: PIE handling
11854fe263eb1b9 Kees Cook          2025-04-25  1111  			 *
11854fe263eb1b9 Kees Cook          2025-04-25  1112  			 * There are effect=
ively two types of ET_DYN ELF
11854fe263eb1b9 Kees Cook          2025-04-25  1113  			 * binaries: progra=
ms (i.e. PIE: ET_DYN with
11854fe263eb1b9 Kees Cook          2025-04-25  1114  			 * PT_INTERP) and l=
oaders (i.e. static PIE: ET_DYN
11854fe263eb1b9 Kees Cook          2025-04-25  1115  			 * without PT_INTER=
P, usually the ELF interpreter
11854fe263eb1b9 Kees Cook          2025-04-25  1116  			 * itself). Loaders=
 must be loaded away from programs
11854fe263eb1b9 Kees Cook          2025-04-25  1117  			 * since the progra=
m may otherwise collide with the
11854fe263eb1b9 Kees Cook          2025-04-25  1118  			 * loader (especial=
ly for ET_EXEC which does not have
11854fe263eb1b9 Kees Cook          2025-04-25  1119  			 * a randomized pos=
ition).
11854fe263eb1b9 Kees Cook          2025-04-25  1120  			 *
11854fe263eb1b9 Kees Cook          2025-04-25  1121  			 * For example, to =
handle invocations of
eab09532d400906 Kees Cook          2017-07-10  1122  			 * "./ld.so somepro=
g" to test out a new version of
eab09532d400906 Kees Cook          2017-07-10  1123  			 * the loader, the =
subsequent program that the
eab09532d400906 Kees Cook          2017-07-10  1124  			 * loader loads mus=
t avoid the loader itself, so
eab09532d400906 Kees Cook          2017-07-10  1125  			 * they cannot shar=
e the same load range. Sufficient
eab09532d400906 Kees Cook          2017-07-10  1126  			 * room for the brk=
 must be allocated with the
eab09532d400906 Kees Cook          2017-07-10  1127  			 * loader as well, =
since brk must be available with
eab09532d400906 Kees Cook          2017-07-10  1128  			 * the loader.
eab09532d400906 Kees Cook          2017-07-10  1129  			 *
eab09532d400906 Kees Cook          2017-07-10  1130  			 * Therefore, progr=
ams are loaded offset from
eab09532d400906 Kees Cook          2017-07-10  1131  			 * ELF_ET_DYN_BASE =
and loaders are loaded into the
eab09532d400906 Kees Cook          2017-07-10  1132  			 * independently ra=
ndomized mmap region (0 load_bias
5f501d555653f89 Kees Cook          2021-11-08  1133  			 * without MAP_FIXE=
D nor MAP_FIXED_NOREPLACE).
11854fe263eb1b9 Kees Cook          2025-04-25  1134  			 *
11854fe263eb1b9 Kees Cook          2025-04-25  1135  			 * See below for "b=
rk" handling details, which is
11854fe263eb1b9 Kees Cook          2025-04-25  1136  			 * also affected by=
 program vs loader and ASLR.
eab09532d400906 Kees Cook          2017-07-10  1137  			 */
aeb7923733d100b Andrew Morton      2022-04-14  1138  			if (interpreter) {
3545deff0ec7a37 Kees Cook          2024-05-08  1139  				/* On ET_DYN with =
PT_INTERP, we do the ASLR. */
eab09532d400906 Kees Cook          2017-07-10 @1140  				load_bias =3D ELF_=
ET_DYN_BASE;
a3defbe5c337dbc Jiri Kosina        2011-11-02  1141  				if (current->flags=
 & PF_RANDOMIZE)
d1fd836dcf00d20 Kees Cook          2015-04-14  1142  					load_bias +=3D ar=
ch_mmap_rnd();
3545deff0ec7a37 Kees Cook          2024-05-08  1143  				/* Adjust alignmen=
t as requested. */
3545deff0ec7a37 Kees Cook          2024-05-08  1144  				if (alignment)
3545deff0ec7a37 Kees Cook          2024-05-08  1145  					load_bias &=3D ~(=
alignment - 1);
3545deff0ec7a37 Kees Cook          2024-05-08  1146  				elf_flags |=3D MAP=
_FIXED_NOREPLACE;
3545deff0ec7a37 Kees Cook          2024-05-08  1147  			} else {
3545deff0ec7a37 Kees Cook          2024-05-08  1148  				/*
3545deff0ec7a37 Kees Cook          2024-05-08  1149  				 * For ET_DYN with=
out PT_INTERP, we rely on
3545deff0ec7a37 Kees Cook          2024-05-08  1150  				 * the architectur=
es's (potentially ASLR) mmap
3545deff0ec7a37 Kees Cook          2024-05-08  1151  				 * base address (v=
ia a load_bias of 0).
3545deff0ec7a37 Kees Cook          2024-05-08  1152  				 *
3545deff0ec7a37 Kees Cook          2024-05-08  1153  				 * When a large al=
ignment is requested, we
3545deff0ec7a37 Kees Cook          2024-05-08  1154  				 * must do the all=
ocation at address "0" right
3545deff0ec7a37 Kees Cook          2024-05-08  1155  				 * now to discover=
 where things will load so
3545deff0ec7a37 Kees Cook          2024-05-08  1156  				 * that we can adj=
ust the resulting alignment.
3545deff0ec7a37 Kees Cook          2024-05-08  1157  				 * In this case (l=
oad_bias !=3D 0), we can use
3545deff0ec7a37 Kees Cook          2024-05-08  1158  				 * MAP_FIXED_NOREP=
LACE to make sure the mapping
3545deff0ec7a37 Kees Cook          2024-05-08  1159  				 * doesn't collide=
 with anything.
3545deff0ec7a37 Kees Cook          2024-05-08  1160  				 */
3545deff0ec7a37 Kees Cook          2024-05-08  1161  				if (alignment > EL=
F_MIN_ALIGN) {
3545deff0ec7a37 Kees Cook          2024-05-08  1162  					load_bias =3D elf=
_load(bprm->file, 0, elf_ppnt,
3545deff0ec7a37 Kees Cook          2024-05-08  1163  							     elf_prot, =
elf_flags, total_size);
3545deff0ec7a37 Kees Cook          2024-05-08  1164  					if (BAD_ADDR(load=
_bias)) {
3545deff0ec7a37 Kees Cook          2024-05-08  1165  						retval =3D IS_ER=
R_VALUE(load_bias) ?
3545deff0ec7a37 Kees Cook          2024-05-08  1166  							 PTR_ERR((void*=
)load_bias) : -EINVAL;
3545deff0ec7a37 Kees Cook          2024-05-08  1167  						goto out_free_de=
ntry;
3545deff0ec7a37 Kees Cook          2024-05-08  1168  					}
3545deff0ec7a37 Kees Cook          2024-05-08  1169  					vm_munmap(load_bi=
as, total_size);
3545deff0ec7a37 Kees Cook          2024-05-08  1170  					/* Adjust alignme=
nt as requested. */
ce81bb256a22425 Chris Kennelly     2020-10-15  1171  					if (alignment)
ce81bb256a22425 Chris Kennelly     2020-10-15  1172  						load_bias &=3D ~=
(alignment - 1);
5f501d555653f89 Kees Cook          2021-11-08  1173  					elf_flags |=3D MA=
P_FIXED_NOREPLACE;
eab09532d400906 Kees Cook          2017-07-10  1174  				} else
eab09532d400906 Kees Cook          2017-07-10  1175  					load_bias =3D 0;
3545deff0ec7a37 Kees Cook          2024-05-08  1176  			}
eab09532d400906 Kees Cook          2017-07-10  1177 =20
eab09532d400906 Kees Cook          2017-07-10  1178  			/*
eab09532d400906 Kees Cook          2017-07-10  1179  			 * Since load_bias =
is used for all subsequent loading
eab09532d400906 Kees Cook          2017-07-10  1180  			 * calculations, we=
 must lower it by the first vaddr
eab09532d400906 Kees Cook          2017-07-10  1181  			 * so that the rema=
ining calculations based on the
eab09532d400906 Kees Cook          2017-07-10  1182  			 * ELF vaddrs will =
be correctly offset. The result
eab09532d400906 Kees Cook          2017-07-10  1183  			 * is then page ali=
gned.
eab09532d400906 Kees Cook          2017-07-10  1184  			 */
eab09532d400906 Kees Cook          2017-07-10  1185  			load_bias =3D ELF_P=
AGESTART(load_bias - vaddr);
^1da177e4c3f415 Linus Torvalds     2005-04-16  1186  		}
^1da177e4c3f415 Linus Torvalds     2005-04-16  1187 =20
585a018627b4d7e Eric W. Biederman  2023-09-28  1188  		error =3D elf_load(b=
prm->file, load_bias + vaddr, elf_ppnt,
a87938b2e246b81 Michael Davidson   2015-04-14  1189  				elf_prot, elf_flag=
s, total_size);
^1da177e4c3f415 Linus Torvalds     2005-04-16  1190  		if (BAD_ADDR(error))=
 {
dc64cc12bcd1421 Bo Liu             2022-11-14  1191  			retval =3D IS_ERR_V=
ALUE(error) ?
b140f25108a8b11 Alexey Kuznetsov   2007-05-08  1192  				PTR_ERR((void*)err=
or) : -EINVAL;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1193  			goto out_free_dentr=
y;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1194  		}
^1da177e4c3f415 Linus Torvalds     2005-04-16  1195 =20
2b4bfbe0967697c Akira Kawata       2022-01-27  1196  		if (first_pt_load) {
2b4bfbe0967697c Akira Kawata       2022-01-27  1197  			first_pt_load =3D 0;
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30  1198  			if (elf_ex->e_type =
=3D=3D ET_DYN) {
^1da177e4c3f415 Linus Torvalds     2005-04-16  1199  				load_bias +=3D err=
or -
^1da177e4c3f415 Linus Torvalds     2005-04-16  1200  				             ELF_P=
AGESTART(load_bias + vaddr);
^1da177e4c3f415 Linus Torvalds     2005-04-16  1201  				reloc_func_desc =
=3D load_bias;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1202  			}
^1da177e4c3f415 Linus Torvalds     2005-04-16  1203  		}
0da1d5002745cdc Akira Kawata       2022-01-27  1204 =20
0da1d5002745cdc Akira Kawata       2022-01-27  1205  		/*
0da1d5002745cdc Akira Kawata       2022-01-27  1206  		 * Figure out which =
segment in the file contains the Program
0da1d5002745cdc Akira Kawata       2022-01-27  1207  		 * Header table, and=
 map to the associated memory address.
0da1d5002745cdc Akira Kawata       2022-01-27  1208  		 */
0da1d5002745cdc Akira Kawata       2022-01-27  1209  		if (elf_ppnt->p_offs=
et <=3D elf_ex->e_phoff &&
0da1d5002745cdc Akira Kawata       2022-01-27  1210  		    elf_ex->e_phoff =
< elf_ppnt->p_offset + elf_ppnt->p_filesz) {
0da1d5002745cdc Akira Kawata       2022-01-27  1211  			phdr_addr =3D elf_e=
x->e_phoff - elf_ppnt->p_offset +
0da1d5002745cdc Akira Kawata       2022-01-27  1212  				    elf_ppnt->p_va=
ddr;
0da1d5002745cdc Akira Kawata       2022-01-27  1213  		}
0da1d5002745cdc Akira Kawata       2022-01-27  1214 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1215  		k =3D elf_ppnt->p_va=
ddr;
f67ef446291a091 Alexey Dobriyan    2020-01-30  1216  		if ((elf_ppnt->p_fla=
gs & PF_X) && k < start_code)
f4e5cc2c44bf760 Jesper Juhl        2006-06-23  1217  			start_code =3D k;
f4e5cc2c44bf760 Jesper Juhl        2006-06-23  1218  		if (start_data < k)
f4e5cc2c44bf760 Jesper Juhl        2006-06-23  1219  			start_data =3D k;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1220 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1221  		/*
^1da177e4c3f415 Linus Torvalds     2005-04-16  1222  		 * Check to see if t=
he section's size will overflow the
^1da177e4c3f415 Linus Torvalds     2005-04-16  1223  		 * allowed task size=
. Note that p_filesz must always be
^1da177e4c3f415 Linus Torvalds     2005-04-16  1224  		 * <=3D p_memsz so i=
t is only necessary to check p_memsz.
^1da177e4c3f415 Linus Torvalds     2005-04-16  1225  		 */
ce51059be56f637 Chuck Ebbert       2006-07-03  1226  		if (BAD_ADDR(k) || e=
lf_ppnt->p_filesz > elf_ppnt->p_memsz ||
^1da177e4c3f415 Linus Torvalds     2005-04-16  1227  		    elf_ppnt->p_mems=
z > TASK_SIZE ||
^1da177e4c3f415 Linus Torvalds     2005-04-16  1228  		    TASK_SIZE - elf_=
ppnt->p_memsz < k) {
^1da177e4c3f415 Linus Torvalds     2005-04-16  1229  			/* set_brk can neve=
r work. Avoid overflows. */
b140f25108a8b11 Alexey Kuznetsov   2007-05-08  1230  			retval =3D -EINVAL;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1231  			goto out_free_dentr=
y;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1232  		}
^1da177e4c3f415 Linus Torvalds     2005-04-16  1233 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1234  		k =3D elf_ppnt->p_va=
ddr + elf_ppnt->p_filesz;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1235 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1236  		if ((elf_ppnt->p_fla=
gs & PF_X) && end_code < k)
^1da177e4c3f415 Linus Torvalds     2005-04-16  1237  			end_code =3D k;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1238  		if (end_data < k)
^1da177e4c3f415 Linus Torvalds     2005-04-16  1239  			end_data =3D k;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1240  		k =3D elf_ppnt->p_va=
ddr + elf_ppnt->p_memsz;
585a018627b4d7e Eric W. Biederman  2023-09-28  1241  		if (k > elf_brk)
^1da177e4c3f415 Linus Torvalds     2005-04-16  1242  			elf_brk =3D k;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1243  	}
^1da177e4c3f415 Linus Torvalds     2005-04-16  1244 =20
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30  1245  	e_entry =3D elf_ex->e=
_entry + load_bias;
0da1d5002745cdc Akira Kawata       2022-01-27  1246  	phdr_addr +=3D load_b=
ias;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1247  	elf_brk +=3D load_bia=
s;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1248  	start_code +=3D load_=
bias;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1249  	end_code +=3D load_bi=
as;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1250  	start_data +=3D load_=
bias;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1251  	end_data +=3D load_bi=
as;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1252 =20
cc338010a233c08 Alexey Dobriyan    2019-05-14  1253  	if (interpreter) {
c69bcc932ef3568 Alexey Dobriyan    2020-04-06  1254  		elf_entry =3D load_e=
lf_interp(interp_elf_ex,
^1da177e4c3f415 Linus Torvalds     2005-04-16  1255  					    interpreter,
fe0f67660ee9c99 Dave Martin        2020-03-16  1256  					    load_bias, in=
terp_elf_phdata,
fe0f67660ee9c99 Dave Martin        2020-03-16  1257  					    &arch_state);
dc64cc12bcd1421 Bo Liu             2022-11-14  1258  		if (!IS_ERR_VALUE(el=
f_entry)) {
cc503c1b43e002e Jiri Kosina        2008-01-30  1259  			/*
cc503c1b43e002e Jiri Kosina        2008-01-30  1260  			 * load_elf_interp(=
) returns relocation
cc503c1b43e002e Jiri Kosina        2008-01-30  1261  			 * adjustment
cc503c1b43e002e Jiri Kosina        2008-01-30  1262  			 */
cc503c1b43e002e Jiri Kosina        2008-01-30  1263  			interp_load_addr =
=3D elf_entry;
c69bcc932ef3568 Alexey Dobriyan    2020-04-06  1264  			elf_entry +=3D inte=
rp_elf_ex->e_entry;
cc503c1b43e002e Jiri Kosina        2008-01-30  1265  		}
^1da177e4c3f415 Linus Torvalds     2005-04-16  1266  		if (BAD_ADDR(elf_ent=
ry)) {
dc64cc12bcd1421 Bo Liu             2022-11-14  1267  			retval =3D IS_ERR_V=
ALUE(elf_entry) ?
ce51059be56f637 Chuck Ebbert       2006-07-03  1268  					(int)elf_entry : =
-EINVAL;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1269  			goto out_free_dentr=
y;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1270  		}
^1da177e4c3f415 Linus Torvalds     2005-04-16  1271  		reloc_func_desc =3D =
interp_load_addr;
^1da177e4c3f415 Linus Torvalds     2005-04-16  1272 =20
0357ef03c94ef83 Amir Goldstein     2024-11-28  1273  		exe_file_allow_write=
_access(interpreter);
^1da177e4c3f415 Linus Torvalds     2005-04-16  1274  		fput(interpreter);
0693ffebcfe5ac7 Alexey Dobriyan    2020-04-06  1275 =20
0693ffebcfe5ac7 Alexey Dobriyan    2020-04-06  1276  		kfree(interp_elf_ex);
aa0d1564b10f916 Alexey Dobriyan    2020-04-06  1277  		kfree(interp_elf_phd=
ata);
^1da177e4c3f415 Linus Torvalds     2005-04-16  1278  	} else {
a62c5b1b6647ea0 Alexey Dobriyan    2020-01-30  1279  		elf_entry =3D e_entr=
y;
5342fba5412cead Suresh Siddha      2006-02-26  1280  		if (BAD_ADDR(elf_ent=
ry)) {
ce51059be56f637 Chuck Ebbert       2006-07-03  1281  			retval =3D -EINVAL;
5342fba5412cead Suresh Siddha      2006-02-26  1282  			goto out_free_dentr=
y;
5342fba5412cead Suresh Siddha      2006-02-26  1283  		}
^1da177e4c3f415 Linus Torvalds     2005-04-16  1284  	}
^1da177e4c3f415 Linus Torvalds     2005-04-16  1285 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1286  	kfree(elf_phdata);
^1da177e4c3f415 Linus Torvalds     2005-04-16  1287 =20
^1da177e4c3f415 Linus Torvalds     2005-04-16  1288  	set_binfmt(&elf_forma=
t);
^1da177e4c3f415 Linus Torvalds     2005-04-16  1289 =20

:::::: The code at line 1140 was first introduced by commit
:::::: eab09532d40090698b05a07c1c87f39fdbc5fab5 binfmt_elf: use ELF_ET_DYN_=
BASE only for PIE

:::::: TO: Kees Cook <keescook@chromium.org>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

